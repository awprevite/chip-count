//
//  HistoryViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import Foundation
import CoreData

class HistoryViewModel: ObservableObject {
    
    init() {}
    
    @Published var sessions: [SessionData] = []
    @Published var cumulativeSessions: [SessionWithAllTotals] = []
    
    var totalSessions: Int { cumulativeSessions.count }
    var totalProfit: Double { cumulativeSessions.last?.runningMoney ?? 0 }
    var totalTime: Int16 { cumulativeSessions.last?.runningTime ?? 0 }
    
    func loadSessions(context: NSManagedObjectContext) {
        
        let request = Session.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Session.date, ascending: true)]
        if let result = try? context.fetch(request) {
            self.sessions = result.map { coreSession in
                SessionData(
                    id: coreSession.objectID,
                    date: coreSession.date ?? Date(),
                    buyIn: coreSession.buyIn,
                    winnings: coreSession.winnings,
                    duration: coreSession.duration
                )
            }
            
            var totalMoney: Double = 0
            var totalTime: Int16 = 0
            self.cumulativeSessions = sessions.map { session in
                totalMoney += session.winnings
                totalTime += session.duration
                return SessionWithAllTotals(session: session, runningMoney: totalMoney, runningTime: totalTime)
            }
        }
    }
    
    func deleteSession(session: SessionData, in context: NSManagedObjectContext) {
        let object = context.object(with: session.id)
        context.delete(object)
        try? context.save()
    }
}
