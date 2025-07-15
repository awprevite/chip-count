//
//  History.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import CoreData
import SwiftUI
import Charts

// make sortable by picker

struct HistoryView: View {
    
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        
        NavigationView {
            
            List(viewModel.sessions.sorted(by: { $0.startTime < $1.startTime })) { session in
                NavigationLink(destination: SessionView(session: session)){
                    HStack {
                        Text(session.location)
                        Spacer()
                        Text(String(format: "%.2f", session.profit))
                        Text(viewModel.formatter.string(from: session.startTime))
                    }
                }
            }
            .onAppear {
                viewModel.fetchAllSessions(context: context)
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryView()
}
