//
//  InputViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//
 
import CoreData
import Foundation 

class InputViewModel: ObservableObject {
    
    let dataViewModel = DataViewModel()
    
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
    @Published var helpLabel: String = ""
    @Published var helpDescription: String = ""
    
    @Published var id: UUID? = nil
    
    init(sessionToEdit: SessionData? = nil){
        if let session = sessionToEdit {
            id = session.id
            startTime = session.startTime
            endTime = session.endTime
            location = session.location
            city = session.city
            locationType = session.locationType
            smallBlind = String(session.smallBlind)
            bigBlind = String(session.bigBlind)
            buyIn = String(session.buyIn)
            cashOut = String(session.cashOut)
            rebuys = String(session.rebuys)
            players = String(session.players)
            badBeats = String(session.badBeats)
            mood = session.mood
            notes = session.notes
        }
    }
    
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
        helpLabel = ""
        helpDescription = ""
    }
    
    func saveSession(context: NSManagedObjectContext) {
            
        guard validateInputs() else { return }
        
        do {
            
            let new = id == nil ? true : false
            
            let inputSession = SessionData(
                id: id ?? UUID(),
                startTime: startTime,
                endTime: endTime,
                location: location,
                city: city,
                locationType: locationType,
                smallBlind: Double(smallBlind) ?? 0,
                bigBlind: Double(bigBlind) ?? 0,
                buyIn: Double(buyIn) ?? 0,
                cashOut: Double(cashOut) ?? 0,
                rebuys: Int(rebuys) ?? 0,
                players: Int(players) ?? 0,
                badBeats: Int(badBeats) ?? 0,
                mood: mood,
                notes: notes
            )
                
            let success: Bool
            
            
            if(new) {
                success = dataViewModel.insertSession(context: context, session: inputSession)
            } else {
                success = dataViewModel.updateSession(context: context, session: inputSession)
            }
            
            if success {
                reset()
                helpLabel = "Success"
                helpDescription = id == nil ? "Session saved" : "Session updated"
                showHelp = true
            } else {
                helpLabel = "Error"
                helpDescription = "Failed to save session"
                showHelp = true
            }
        }
    }
}
