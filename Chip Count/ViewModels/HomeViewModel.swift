//
//  ContentViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import Foundation
import CoreData
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var sessions: [SessionData] = [] {
        didSet {
            calculateStats()
        }
    }
    
    @Published var numSessions: Double = 0.0
    @Published var totalProfit: Double = 0.0
    @Published var avgProfit: Double = 0.0
    @Published var hourlyProfit: Double = 0.0
    @Published var totalDuration: Double = 0.0 // Duration in minutes
    @Published var avgDuration: Double = 0.0   // Duration in minutes

    var numSessionsString: String {
        return String(format: "%.0f", numSessions) // Use %.0f for whole numbers
    }
    var totalProfitString: String {
        return String(format: "$%.2f", totalProfit)
    }
    var avgProfitString: String {
        return String(format: "$%.2f", avgProfit)
    }
    var hourlyProfitString: String {
        return String(format: "$%.2f", hourlyProfit)
    }
    var totalDurationString: String {
        let totalHours = Int(totalDuration / 60)
        let totalMinutes = Int(totalDuration.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", totalHours, totalMinutes)
    }
    var avgDurationString: String {
        let avgHours = Int(avgDuration / 60)
        let avgMinutes = Int(avgDuration.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", avgHours, avgMinutes)
    }
    
    func calculateStats() {
        
        totalProfit = 0.0
        totalDuration = 0.0
        
        for session in sessions{
            totalProfit += session.profit
            totalDuration += Double(session.duration)
        }
        
        numSessions = Double(sessions.count)
        
        if numSessions > 0 {
            avgProfit = totalProfit / numSessions
            avgDuration = totalDuration / numSessions
        } else {
            avgProfit = 0.0
            avgDuration = 0.0
        }
        
        if totalDuration > 0 {
            hourlyProfit = totalProfit / (totalDuration / 60)
        } else {
            hourlyProfit = 0.0
        }
    }
    
    func loadSessions(context: NSManagedObjectContext) {
        
        let request = Session.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Session.startTime, ascending: true)]
        
        if let result = try? context.fetch(request) {
            self.sessions = result.map { coreSession in
                SessionData(
                    id: coreSession.id ?? UUID(),
                    startTime: coreSession.startTime ?? Date(),
                    endTime: coreSession.endTime ?? Date(),
                    location: coreSession.location ?? "",
                    city: coreSession.city ?? "",
                    locationType: coreSession.locationType ?? "Home" ,
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
        }
    }
}
