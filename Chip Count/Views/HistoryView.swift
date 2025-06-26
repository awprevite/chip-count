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
        
        List(sessions.sorted(by: { $0.startTime > $1.startTime })) { session in
            NavigationLink(destination: SessionView(session: session)){
                HStack {
                    Text(session.location)
                    Spacer()
                    Text(String(format: "%.2f", session.profit))
                    Text(formatter.string(from: session.startTime))
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
