//
//  HistoryViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import Foundation
import CoreData

class HistoryViewModel: ObservableObject {
    
    let dataViewModel = DataViewModel()
    
    @Published var sessions: [SessionData] = []
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f
    }()

    func fetchAllSessions(context: NSManagedObjectContext) {
        if let allSessions = dataViewModel.fetchAllSessions(context: context){
            self.sessions = allSessions
        } else {
            self.sessions = []
        }
    }
}
