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
                    
                    TableView(sessions: sessions, viewContext: viewContext)
                    
                    Spacer()
                    
                }
            }
        }
    }
}

struct GraphView: View {
    
    let sessions: [SessionData]
    
    var total: Double = 0
    
    var cumulativeSessions: [SessionWithTotal] {
        var total: Double = 0
        
        return sessions.map { session in
            total += session.winnings
            return SessionWithTotal(session: session, runningTotal: total)
        }
    }
    
    
    var body: some View {
        Chart(cumulativeSessions) { entry in
                        
            LineMark(
                x: .value("Date", entry.session.date),
                y: .value("Net", entry.runningTotal)
            )
            .foregroundStyle(entry.session.winnings >= 0 ? .green : .red)

        }
        .chartXAxis {
            AxisMarks(preset: .aligned, values: .automatic) { value in
                AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                    .foregroundStyle(.white)
            }
        }
        .chartYAxis {
            AxisMarks() {
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
    
    let sessions: [SessionData]
    let viewContext: NSManagedObjectContext

    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                Text("Date")
                    .modifier(SmallTextStyle(color: .white))
                
                Spacer()
                
                Text("Net")
                    .modifier(SmallTextStyle(color: .white))
                
                Spacer()
                
                Text ("Remove")
                    .modifier(SmallTextStyle(color: .white))
                
            }
            ForEach(sessions) { session in
                HStack {
                    Text(session.date, style: .date)
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .leading)
                    
                    Spacer()

                    Text(String(format: "$%.2f", session.winnings))
                        .foregroundColor(session.winnings >= 0 ? .green : .red)
                        .frame(width: 100, alignment: .trailing)
                    
                    Spacer()
                    
                    Button(action: {deleteSession(session)}) {
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
    }
    
    private func deleteSession(_ session: SessionData) {
        let object = viewContext.object(with: session.id)
        viewContext.delete(object)
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete session: \(error.localizedDescription)")
        }
    }
}

#Preview {
    HistoryView()
}
