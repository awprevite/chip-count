//
//  HistoryViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import Foundation
import CoreData

class HistoryViewModel: ObservableObject {
    
    @Published var sessions: [SessionData] = []
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f
    }()

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
}
