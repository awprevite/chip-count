//
//  ContentViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import Foundation
import CoreData

class ContentViewModel: ObservableObject {
    
    init() {}
    
    @Published var sessions: [SessionData] = []
    @Published var cumulativeSessions: [SessionWithAllTotals] = []
    
    var totalSessions: Int { cumulativeSessions.count }
    var totalProfit: Double { cumulativeSessions.last?.runningMoney ?? 0 }
    var totalTime: Int16 { cumulativeSessions.last?.runningTime ?? 0 }
    
    var hourlyRate: Double {
        let time = Double(totalTime)
        return time > 0 ? totalProfit / (time / 60.0) : 0
    }
    
    var averageDuration: String {
        guard totalSessions > 0 else { return "0:00" }
        
        let averageDurationMinutes = Int(totalTime) / totalSessions
        let hours = averageDurationMinutes / 60
        let minutes = averageDurationMinutes % 60
        return String(format: "%d:%02d", hours, minutes)
    }
    
    var averageProfit: Double {
        guard totalSessions > 0 else { return 0 }
        
        return totalProfit / Double(totalSessions)
    }
    
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
}
