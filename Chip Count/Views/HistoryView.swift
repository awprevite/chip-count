//
//  History.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import SwiftUI
import Charts
import CoreData

struct SessionData: Identifiable {
    let id: NSManagedObjectID
    let date: Date
    let buyIn: Double
    let winnings: Double
    let duration: Int16
}

struct SessionWithTotal: Identifiable {
    let id = UUID()
    let session: SessionData
    let runningTotal: Double
}

struct HistoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Session.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)]
    ) private var sessionsFetched: FetchedResults<Session>
    
    var sessions: [SessionData] {
        sessionsFetched.map { coreSession in
            SessionData(
                id: coreSession.objectID,
                date: coreSession.date ?? Date(),
                buyIn: coreSession.buyIn,
                winnings: coreSession.winnings,
                duration: coreSession.duration
            )
        }
    }
    
    @State private var showAlert = false
    @State private var sessionToDelete: SessionData? = nil
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            ScrollView{
                
                VStack{
                    
                    Text("History")
                        .modifier(SmallTextStyle(color: .white))
                    
                    Divider()
                        .frame(width: 350)
                        .frame(height: 2)
                        .background(Color.white)
                        .padding(.vertical, 8)
                    
                    Spacer()
                    
                    GraphView(sessions: sessions)
                    
                    Spacer()
                    
                    TableView(showAlert: $showAlert, sessionToDelete: $sessionToDelete, sessions: sessions, viewContext: viewContext)
                        .padding()
                    
                    Spacer()
                    
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
            result.append(lastTotal + session.winnings)
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

struct TableView: View {
    
    @Binding var showAlert: Bool
    @Binding var sessionToDelete: SessionData?
    
    let sessions: [SessionData]
    let viewContext: NSManagedObjectContext
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f
    }()


    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                Text("Date")
                    .modifier(SmallTextStyle(color: .white))
                
                Spacer()
                Spacer()
                
                Text("Net")
                    .modifier(SmallTextStyle(color: .white))
                
                Spacer()
                
            }
            ForEach(sessions) { session in
                HStack {
                    Text(formatter.string(from: session.date))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .frame(width: 100, alignment: .leading)
                    
                    Spacer()

                    Text(String(format: "$%.2f", session.winnings))
                        .foregroundColor(session.winnings > 0 ? .green : (session.winnings == 0 ? .white : .red))
                        .frame(width: 100, alignment: .trailing)
                    
                    Spacer()
                    
                    Button(action: {
                        sessionToDelete = session
                        showAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }

                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth:2)
        )
        .alert("Delete Session? This cannot be undone", isPresented: $showAlert, presenting: sessionToDelete) { session in
            Button("Delete", role: .destructive) {
                deleteSession(session)
            }
            Button("Back", role: .cancel) {}
        } message: { _ in}

    }
    
    private func deleteSession(_ session: SessionData) {
        let object = viewContext.object(with: session.id)
        viewContext.delete(object)
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete")
        }
    }
}

#Preview {
    HistoryView()
}
