//
//  AnalyticViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/22/25.
//

import Foundation
import Charts
import CoreData

class AnalyticViewModel: ObservableObject {
    
    let dataViewModel = DataViewModel()
    
    @Published var sessions: [SessionData] = []
    
    // Grouping options for aggregating
    enum GroupBy: String, CaseIterable {
        case location = "Location"
        case city = "City"
        case locationType = "Location Type"
        case players = "Players"
        case day = "Day"
        case month = "Month"
        case year = "Year"
    }
    
    // Metrics available for analysis and visualization
    enum Metric: String, CaseIterable {
        case buyIn = "Buy In"
        case rebuys = "Rebuys"
        case profit = "Profit"
        case duration = "Duration"
        case badBeats = "Bad Beats"
        case mood = "Mood"
    }
    
    @Published var selectedGroupBy: GroupBy = .locationType
    @Published var selectedMetric: Metric = .profit
    
    // One bar in the bar chart
    struct BarEntry: Identifiable {
        let id = UUID()
        let groupName: String
        let metricName: String
        let average: Double
    }
    
    // One point in the cumulative profit line chart
    struct LineEntry: Identifiable {
        let id = UUID()
        let date: Date
        let cumulativeProfit: Double
    }
    
    // Computes average metric values grouped by selected grouping
    var averagedEntries: [BarEntry] {
        let grouped = Dictionary(grouping: sessions, by: groupKey)
        var result: [BarEntry] = []
        
        for (group, sessions) in grouped {
            let avg = sessions.map(metricValue).reduce(0, +) / Double(sessions.count)
            result.append(BarEntry(groupName: group, metricName: selectedMetric.rawValue, average: avg))
        }
        return result.sorted { $0.groupName < $1.groupName }
    }
    
    // Computes cumulative profit over time sorted by time
    var cumulativeEntries: [LineEntry] {
        var result: [LineEntry] = []
        var total: Double = 0.0
        
        for session in sessions.sorted(by: { $0.startTime < $1.endTime }) {
            total += session.profit
            result.append(LineEntry(date: session.startTime, cumulativeProfit: total))
        }
        return result
    }
    
    // Returns grouping key string for a session based on current selected group by option
    func groupKey(for session: SessionData) -> String {
        switch selectedGroupBy {
        case .location: return session.location
        case .city: return session.city
        case .locationType: return session.locationType
        case .players: return String(session.players)
        case .day: return session.day
        case .month: return session.month
        case .year: return session.year
        }
    }
    
    // Returns metric value for a session based on current selected metruc option
    func metricValue(for session: SessionData) -> Double {
        switch selectedMetric {
        case .buyIn: return session.buyIn
        case .rebuys: return Double(session.rebuys)
        case .profit: return session.profit
        case .duration: return Double(session.duration)
        case .badBeats: return Double(session.badBeats)
        case .mood: return Double(session.mood)
        }
    }
    
    
//    //HeatMap calendar stuff here
//    @Published var selectedYear: Int
//    @Published var selectedMonth: Int
//    @Published var dayProfits: [Date: Double] = [:]
//    
//    func color(for value: Double) -> Color {
//        switch value {
//        case 0: return Color.gray.opacity(0.1)
//        case 1..<3: return Color.green.opacity(0.3)
//        case 3..<6: return Color.green.opacity(0.6)
//        case 6...: return Color.green
//        default: return Color.clear
//        }
//    }
    
    func fetchAllSessions(context: NSManagedObjectContext) {
        if let allSessions = dataViewModel.fetchAllSessions(context: context){
            self.sessions = allSessions
        } else {
            self.sessions = []
        }
    }
}
