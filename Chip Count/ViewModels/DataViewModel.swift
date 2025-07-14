//
//  DataViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 7/14/25.
//

import CoreData

class DataViewModel: ObservableObject {
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
    
    func saveSession(context: NSManagedObjectContext, session: SessionData, edit: Bool) -> Int {
            
        // Should only receive valid inputs, do check elsewhere
        
        do {
        
            let coreSession: Session
                
            if edit {
                
                let request: NSFetchRequest<Session> = Session.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)
                request.fetchLimit = 1
                
                if let existing = try context.fetch(request).first {
                    coreSession = existing
                } else {
                    coreSession = Session(context: context)
                    coreSession.id = session.id
                }
            }
            else {
                coreSession = Session(context: context)
                coreSession.id = UUID()
            }
            
            coreSession.startTime = session.startTime
            coreSession.endTime = session.endTime
            coreSession.location = session.location
            coreSession.city = session.city
            coreSession.locationType = session.locationType
            coreSession.smallBlind = Double(session.smallBlind)
            coreSession.bigBlind = Double(session.bigBlind)
            coreSession.buyIn = Double(session.buyIn)
            coreSession.cashOut = Double(session.cashOut)
            coreSession.rebuys = Int32(session.rebuys)
            coreSession.players = Int32(session.players)
            coreSession.badBeats = Int32(session.badBeats)
            coreSession.mood = Int32(session.mood)
            coreSession.notes = session.notes
            
            try context.save()
            return 1
            
        } catch {
            return -1
        }
    }
    
    func deleteSession(context: NSManagedObjectContext, session: SessionData) -> Int {
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let sessionToDelete = results.first {
                context.delete(sessionToDelete)
                try context.save()
                print("Deleted session with id: \(session.id)")
                return 1
            }
        } catch {
            print("Failed to delete session: \(error)")
            return -1
        }
        
        return -1
    }
    
    func reloadSession(context: NSManagedObjectContext, session: SessionData) -> SessionData? {
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)
        request.fetchLimit = 1

        do {
            if let updated = try context.fetch(request).first {
                
                return SessionData(from: updated)
                
            }
        } catch {
            print("Failed to reload session: \(error)")
        }
        return nil
    }
}
