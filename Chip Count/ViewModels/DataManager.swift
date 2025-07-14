//
//  DataManager.swift
//  Chip Count
//
//  Created by Anthony Previte on 7/14/25.
//

import CoreData

class DataManager: ObservableObject {
    @Published var sessions: [SessionData] = []
    
    func loadSessions(context: NSManagedObjectContext) {
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Session.startTime, ascending: true)]

        do {
            let result = try context.fetch(request)
            self.sessions = result.map { coreSession in
                SessionData(
                    id: coreSession.id ?? UUID(),
                    startTime: coreSession.startTime ?? Date(),
                    endTime: coreSession.endTime ?? Date(),
                    location: coreSession.location ?? "",
                    city: coreSession.city ?? "",
                    locationType: coreSession.locationType ?? "",
                    smallBlind: coreSession.smallBlind,
                    bigBlind: coreSession.bigBlind,
                    buyIn: coreSession.buyIn,
                    cashOut: coreSession.cashOut,
                    rebuys: Int(coreSession.rebuys),
                    players: Int(coreSession.players),
                    badBeats: Int(coreSession.badBeats),
                    mood: Int(coreSession.mood),
                    notes: coreSession.notes ?? ""
                )
            }
        } catch {
            print("Error fetching sessions: \(error)")
        }
    }
    
    func saveSession(context: NSManagedObjectContext, session: SessionData) {
            
        // Should only recieve valid inputs, do check elsewhere
        
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
    
    func deleteSession(session: SessionData, context: NSManagedObjectContext) {
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let sessionToDelete = results.first {
                context.delete(sessionToDelete)
                try context.save()
                print("Deleted session with id: \(session.id)")
            }
        } catch {
            print("Failed to delete session: \(error)")
        }
    }
    
    func reloadSession(context: NSManagedObjectContext) {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)
        request.fetchLimit = 1

        do {
            if let updated = try context.fetch(request).first {
                session = SessionData(
                    id: updated.id ?? UUID(),
                    startTime: updated.startTime ?? Date(),
                    endTime: updated.endTime ?? Date(),
                    location: updated.location ?? "",
                    city: updated.city ?? "",
                    locationType: updated.locationType ?? "",
                    smallBlind: updated.smallBlind,
                    bigBlind: updated.bigBlind,
                    buyIn: updated.buyIn,
                    cashOut: updated.cashOut,
                    rebuys: Int(updated.rebuys),
                    players: Int(updated.players),
                    badBeats: Int(updated.badBeats),
                    mood: Int(updated.mood),
                    notes: updated.notes ?? ""
                )
            }
        } catch {
            print("Failed to reload session: \(error)")
        }
    }
}
