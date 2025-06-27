//
//  InputViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import CoreData
import Foundation 

class InputViewModel: ObservableObject {
    
    @Published var startTime: Date = (Calendar.current.date(byAdding: .hour, value: -3, to: Date()) ?? Date())
    @Published var endTime: Date = Date()
    @Published var location: String = ""
    @Published var city: String = ""
    let locationTypeOptions = ["Home", "Casino", "Online"]
    @Published var locationType: String = "Home"
    @Published var smallBlind: String = ""
    @Published var bigBlind: String = ""
    @Published var buyIn: String = ""
    @Published var cashOut: String = ""
    @Published var rebuys: String = ""
    @Published var players: String = ""
    @Published var badBeats: String = ""
    @Published var mood: Int = 3
    @Published var notes: String = ""
    
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    @Published var showHelp: Bool = false
    @Published var helpLabel: String? = nil
    @Published var helpDescription: String = ""
    
    func help(label: String) {
        helpLabel = label
        helpDescription = inputDescriptions[label] ?? ""
        showHelp = true
    }
    
    func validateInputs() -> Bool {
        guard endTime > startTime else {
            errorMessage = "Please enter an End Time and a Start Time that is before the End Time."
            showError = true
            return false
        }
        
        let maxDuration: TimeInterval = 48 * 60 * 60
        if endTime.timeIntervalSince(startTime) > maxDuration {
            errorMessage = "Session duration cannot exceed 48 hours."
            showError = true
            return false
        }
        
        guard Double(buyIn) != nil, Double(cashOut) != nil else {
            errorMessage = "Please enter valid amounts for Buy In and Cash Out."
            showError = true
            return false
        }
        return true
    }
    
    func saveSession(context: NSManagedObjectContext, dismiss: () -> Void) {
        
        print("Save tapped")
        
        guard validateInputs() else { return }
        
        let newSession: SessionData = SessionData(
            id: UUID(),
            startTime: startTime,
            endTime: endTime,
            location: location,
            city: city,
            locationType: locationType,
            smallBlind: Double(smallBlind) ?? -1,
            bigBlind: Double(bigBlind) ?? -1,
            buyIn: Double(buyIn) ?? -1.0,
            cashOut: Double(cashOut) ?? -1.0,
            rebuys: Int(rebuys) ?? -1,
            players: Int(players) ?? -1,
            badBeats: Int(badBeats) ?? -1,
            mood: Int(mood),
            notes: notes
        )
        
        let newCoreSession = Session(context: context)
        newCoreSession.startTime = newSession.startTime
        newCoreSession.endTime = newSession.endTime
        newCoreSession.location = newSession.location
        newCoreSession.city = newSession.city
        newCoreSession.locationType = newSession.locationType
        newCoreSession.smallBlind = newSession.smallBlind
        newCoreSession.bigBlind = newSession.bigBlind
        newCoreSession.buyIn = newSession.buyIn
        newCoreSession.cashOut = newSession.cashOut
        newCoreSession.rebuys = Int32(newSession.rebuys)
        newCoreSession.players = Int32(newSession.players)
        newCoreSession.badBeats = Int32(newSession.badBeats)
        newCoreSession.mood = Int32(newSession.mood)
        newCoreSession.notes = newSession.notes
        
        do {
            
            try context.save()
            reset()
            dismiss()
            
        } catch {
            errorMessage = "Failed to save sesson: \(error.localizedDescription)"
            showError = true
        }
    }
    
    func reset() {
        startTime = Calendar.current.date(byAdding: .hour, value: -3, to: Date()) ?? Date()
        endTime = Date()
        location = ""
        city = ""
        locationType = "Home"
        smallBlind = ""
        bigBlind = ""
        buyIn = ""
        cashOut = ""
        rebuys = ""
        players = ""
        badBeats = ""
        mood = 3
        notes = ""

        errorMessage = ""
        showError = false
        showHelp = false
        helpLabel = nil
        helpDescription = ""
    }
}
