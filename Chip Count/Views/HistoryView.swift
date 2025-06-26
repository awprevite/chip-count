//
//  History.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import CoreData
import SwiftUI
import Charts

struct HistoryView: View {
    
    @StateObject private var viewModel = HistoryViewModel()
    
    let sessions: [SessionData] = mockData
    
        let formatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "MMM d, yyyy"
            return f
        }()
    
    var body: some View {
        
        //GraphView(sessions: sessions)
        
        List(sessions.sorted(by: { $0.date > $1.date })) { session in
            NavigationLink(destination: SessionView(session: session)){
                HStack {
                    Text(session.location)
                    Spacer()
                    Text(String(format: "%.2f", session.profit))
                    Text(formatter.string(from: session.date))
                }
            }
        }
    }
}

struct GraphView: View {
    
    let sessions: [SessionData]

    var values: [Double] {
        var result: [Double] = []
        for session in sessions {
            let lastTotal = result.last ?? 0.0
            result.append(lastTotal + session.profit)
        }
        return result
    }

    var dates: [Date] {
        var result: [Date] = []
        for session in sessions {
            result.append(session.date)
        }
        return result
    }
    
    var body: some View {
        
        Chart {
            
            ForEach(Array(zip(values.indices, zip(dates, values))), id: \.0) { index, pair in
                let (date, value) = pair
                PointMark(
                    x: .value("Date", date),
                    y: .value("Total", value)
                )
                .foregroundStyle(.white)
                if index > 0 {
                    let prevValue = values[index - 1]
                    LineMark(
                        x: .value("Date", dates[index - 1]),
                        y: .value("Total", prevValue)
                    )
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Total", value)
                    )
                }
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
        .frame(height: 300)
        .padding()
    }
}

#Preview {
    HistoryView()
}
