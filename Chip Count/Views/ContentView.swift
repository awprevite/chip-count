//
//  ContentView.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import SwiftUI

struct SessionWithAllTotals: Identifiable {
    let id = UUID()
    let session: SessionData
    let runningMoney: Double
    let runningTime: Int16
}

struct ContentView: View {
    
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
    
    var cumulativeSessions: [SessionWithAllTotals] {
        var totalMoney: Double = 0
        var totalTime: Int16 = 0
        
        return sessions.map { session in
            totalMoney += session.winnings
            totalTime += session.duration
            return SessionWithAllTotals(session: session, runningMoney: totalMoney, runningTime: totalTime)
        }
    }
    
    var body: some View {
        
        NavigationStack{
            
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    
                    Text("Balance")
                        .modifier(SmallTextStyle(color: .white))
                    
                    if let last = cumulativeSessions.last {
                        Text(String(format: "$%.2f", last.runningMoney))
                            .modifier(LargeTextStyle(color: last.runningMoney == 0 ? .white : (last.runningMoney > 0 ? .green : .red)))
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                            .padding()
                    } else {
                        Text("$0.00")
                            .modifier(LargeTextStyle(color: .white))
                            .padding()
                    }
                    
                    Divider()
                        .frame(width: 350)
                        .frame(height: 2)
                        .background(Color.white)
                        .padding(.vertical, 8)
                    
                    VStack(alignment: .leading) {
                        
                        Text("Total Sessions")
                            .modifier(SmallTextStyle(color: .white))
                        
                        Text("\(cumulativeSessions.count)")
                            .modifier(LargeTextStyle(color: .white))
                        
                        Text("Time Played")
                            .modifier(SmallTextStyle(color: .white))
                        
                        if let last = cumulativeSessions.last {
                            Text(String(format: "%d:%02d", last.runningTime / 60, last.runningTime % 60))
                                .modifier(LargeTextStyle(color: .white))
                        } else {
                            Text("0:00")
                                .modifier(LargeTextStyle(color: .white))
                        }
                        
                        Text("Hourly Rate")
                            .modifier(SmallTextStyle(color: .white))
                        
                        if let last = cumulativeSessions.last {
                            let hours = Double(last.runningTime) / 60.0
                            let hourlyRate = last.runningMoney / hours
                            Text(String(format: "$%.2f", hourlyRate))
                                .modifier(LargeTextStyle(color: .white))
                        } else {
                            Text("$0.00")
                                .modifier(LargeTextStyle(color: .white))
                        }
                        
                        Text("Average Duration")
                            .modifier(SmallTextStyle(color: .white))
                        
                        if let last = cumulativeSessions.last {
                            let count = cumulativeSessions.count
                            let totalMinutes = Int(last.runningTime)
                            let averageDurationMinutes = totalMinutes / count
                            let hours = averageDurationMinutes / 60
                            let minutes = averageDurationMinutes % 60
                            
                            Text(String(format: "%d:%02d", hours, minutes))
                                .modifier(LargeTextStyle(color: .white))
                        } else {
                            Text("0:00")
                                .modifier(LargeTextStyle(color: .white))
                        }
                        
                        Text("Average Earnings")
                            .modifier(SmallTextStyle(color: .white))
                        
                        if let last = cumulativeSessions.last {
                            let count = cumulativeSessions.count
                            let totalWinnings = last.runningMoney
                            let averageWinnings = totalWinnings / Double(count)
                            
                            Text(String(format: "$%.2f", averageWinnings))
                                .modifier(LargeTextStyle(color: .white))
                        } else {
                            Text("$0.00")
                                .modifier(LargeTextStyle(color: .white))
                        }
                        
                    }
                    .frame(maxWidth: 325, alignment: .leading)
                    
                    Spacer()
                    
                    Divider()
                        .frame(width: 350)
                        .frame(height: 2)
                        .background(Color.white)
                        .padding(.vertical, 8)
                    
                    Spacer()
                    
                    NavigationLink(destination: InputView()){
                        Text("New Session")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Spacer()
                    
                    NavigationLink(destination: HistoryView()){
                        Text("View History")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Spacer()
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
