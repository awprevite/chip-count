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
    
    @Published var _sessionToEditID: UUID? = nil
    
    var sessionToEditID: UUID? {
        _sessionToEditID
    }
    
    init(sessionToEdit: SessionData? = nil){
        if let session = sessionToEdit {
            _sessionToEditID = session.id
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
    
    func saveSession(context: NSManagedObjectContext) {
            
        guard validateInputs() else { return }
        
        do {
            let coreSession: Session
            
            if let id = sessionToEditID {
                let request: NSFetchRequest<Session> = Session.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                request.fetchLimit = 1
                
                if let existing = try context.fetch(request).first {
                    coreSession = existing
                } else {
                    coreSession = Session(context: context)
                    coreSession.id = id
                }
            } else {
                coreSession = Session(context: context)
                coreSession.id = UUID()
            }
        
            coreSession.startTime = startTime
            coreSession.endTime = endTime
            coreSession.location = location
            coreSession.city = city
            coreSession.locationType = locationType
            coreSession.smallBlind = Double(smallBlind) ?? -1
            coreSession.bigBlind = Double(bigBlind) ?? -1
            coreSession.buyIn = Double(buyIn) ?? -1.0
            coreSession.cashOut = Double(cashOut) ?? -1.0
            coreSession.rebuys = Int32(rebuys) ?? -1
            coreSession.players = Int32(players) ?? -1
            coreSession.badBeats = Int32(badBeats) ?? -1
            coreSession.mood = Int32(mood)
            coreSession.notes = notes
            
            try context.save()
            
            if sessionToEditID == nil {
                reset()
            }
            
            helpLabel = "Success"
            helpDescription = sessionToEditID == nil ? "Session saved" : "Session updated"
            showHelp = true
            
        } catch {
            helpLabel = "Error"
            helpDescription = "Failed to save session: \(error.localizedDescription)"
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
