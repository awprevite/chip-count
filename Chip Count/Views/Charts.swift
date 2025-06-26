//
//  Charts.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/26/25.
//

import SwiftUI
import Foundation
import Charts

let sessions: [SessionData] = mockData

// need to deal with overflow
struct BarChart: View {
    
    let data: [SessionData] = sessions
    
    struct Entry: Identifiable {
            let id = UUID()
            let groupName: String
            let metricName: String
            let average: Double
        }
    
    enum GroupBy: String, CaseIterable {
        case location = "Location"
        case city = "City"
        case locationType = "Location Type"
        case players = "Players"
        case day = "Day"
        case month = "Month"
        case year = "Year"
    }
    
    enum Metric: String, CaseIterable {
        case buyIn = "Buy In"
        case rebuys = "Rebuys"
        case profit = "Profit"
        case duration = "Duration"
        case badBeats = "Bad Beats"
        case mood = "Mood"
    }
    
    @State private var selectedGroupBy: GroupBy = .locationType
    @State private var selectedMetric: Metric = .profit
    
    // Extract group key from session
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
    
    // Extract metric value from session
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
        
    var averagedEntries: [Entry] {
        let grouped = Dictionary(grouping: data, by: groupKey)
        var result: [Entry] = []
        
        for (group, sessions) in grouped {
            let avg = sessions.map(metricValue).reduce(0, +) / Double(sessions.count)
            result.append(Entry(groupName: group, metricName: selectedMetric.rawValue, average: avg))
        }
        return result.sorted { $0.groupName < $1.groupName }
    }

    var body: some View {
        VStack {
            Picker("Metric", selection: $selectedMetric) {
                ForEach(Metric.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            Chart {
                ForEach(averagedEntries) { entry in
                    BarMark(
                        x: .value("Group", entry.groupName),
                        y: .value("Average", entry.average)
                    )
                    .foregroundStyle(by: .value("Metric", entry.metricName))
                }
            }
            .padding()
            
            Picker("Group By", selection: $selectedGroupBy) {
                ForEach(GroupBy.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}


struct LineGraph: View {
    
    let data: [SessionData] = sessions
    
    struct Entry: Identifiable {
        let id = UUID()
        let date: Date
        let cumulativeProfit: Double
    }
    
    var cumulativeEntries: [Entry] {
        var result: [Entry] = []
        var total: Double = 0.0
        
        for session in data.sorted(by: { $0.startTime < $1.endTime }) {
            total += session.profit
            result.append(Entry(date: session.startTime, cumulativeProfit: total))
        }
        return result
    }
    
    var body: some View {
        
        Chart {
            ForEach(cumulativeEntries) { entry in
                LineMark(x: .value("Date", entry.date), y: .value("Profit", entry.cumulativeProfit))
                PointMark(x: .value("Date", entry.date), y: .value("Profit", entry.cumulativeProfit))
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartXScale(range: .plotDimension(padding: 10))
        .chartYAxis {
            AxisMarks{
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .padding()

    }
}

#Preview {
    LineGraph()
}
