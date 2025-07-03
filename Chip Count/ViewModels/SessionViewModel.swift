//
//  SessionViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/22/25.
//

import Foundation
import CoreData

class SessionViewModel: ObservableObject {
    
    @Published var session: SessionData
    
    init(session: SessionData) {
        self.session = session
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
