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
    
    @Published var showHelp: Bool = false
    @Published var helpLabel: String? = nil
    @Published var helpDescription: String = ""
    
    func discard() {
        helpLabel = "Discard"
        helpDescription = "Are you sure you want to discard your changes?"
        showHelp = true
    }
    func help(label: String) {
        helpLabel = label
        helpDescription = inputDescriptions[label] ?? ""
        showHelp = true
    }
    
    func validateInputs() -> Bool {
        guard endTime > startTime else {
            helpLabel = "Error"
            helpDescription = inputDescriptions["Time Error"] ?? ""
            showHelp = true
            return false
        }
        
        let maxDuration: TimeInterval = 48 * 60 * 60
        if endTime.timeIntervalSince(startTime) > maxDuration {
            helpLabel = "Error"
            helpDescription = inputDescriptions["Long Time Error"] ?? ""
            showHelp = true
            return false
        }
        
        guard Double(buyIn) != nil, Double(cashOut) != nil else {
            helpLabel = "Error"
            helpDescription = inputDescriptions["Money Error"] ?? ""
            showHelp = true
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
            helpLabel = "Error"
            helpDescription = "Failed to save sesson: \(error.localizedDescription)"
            showHelp = true
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

        showHelp = false
        helpLabel = nil
        helpDescription = ""
    }
}
