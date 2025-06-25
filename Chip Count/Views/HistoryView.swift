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
    
    let sessions: [SessionData]
    
    var body: some View {
        
        Text("Sample")
        
//        List(sessions) { session in
//            NavigationLink(destination: SessionView(session: session)){
//                HStack {
//                    Text(session.location)
//                    Text("\(session.buyIn - session.winnings)")
//                }
//            }
//        }
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
                    .foregroundStyle(.white)
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Total", value)
                    )
                    .foregroundStyle(.white)
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(.white)
            }
        }
        .chartXScale(range: .plotDimension(padding: 10))
        .chartYAxis {
            AxisMarks{
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
                    .foregroundStyle(.white)
            }
        }
        .frame(height: 300)
        .padding()
    }
}

//struct TableView: View {
//    
//    @Binding var showAlert: Bool
//    @Binding var sessionToDelete: SessionData?
//    
//    let sessions: [SessionData]
//    let viewContext: NSManagedObjectContext
//    let onDelete: (SessionData) -> Void
//    
//    let formatter: DateFormatter = {
//        let f = DateFormatter()
//        f.dateFormat = "MMM d, yyyy"
//        return f
//    }()
//
//    var body: some View {
//        
//        VStack(alignment: .leading) {
//
//            HStack {
//                
//                Text("Date")
//                    .modifier(SmallTextStyle(color: .white))
//                
//                Spacer()
//                Spacer()
//                
//                Text("Net")
//                    .modifier(SmallTextStyle(color: .white))
//                
//                Spacer()
//                
//            }
//            
//            ForEach(sessions) { session in
//                HStack {
//                    Text(formatter.string(from: session.date))
//                        .foregroundColor(.white)
//                        .lineLimit(1)
//                        .frame(width: 100, alignment: .leading)
//                    
//                    Spacer()
//
//                    Text(String(format: "$%.2f", session.winnings))
//                        .foregroundColor(session.winnings > 0 ? .green : (session.winnings == 0 ? .white : .red))
//                        .frame(width: 100, alignment: .trailing)
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        sessionToDelete = session
//                        showAlert = true
//                    }) {
//                        Image(systemName: "trash")
//                            .foregroundColor(.red)
//                    }
//
//                }
//                .padding(.vertical, 4)
//            }
//        }
//        .padding()
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.white, lineWidth:2)
//        )
//        .alert("Delete Session? This cannot be undone", isPresented: $showAlert, presenting: sessionToDelete) { session in
//            Button("Delete", role: .destructive) {
//                onDelete(session)
//            }
//            Button("Back", role: .cancel) {}
//        } message: { _ in}
//    }
//}

#Preview {
    HistoryView(sessions: mockData)
}
