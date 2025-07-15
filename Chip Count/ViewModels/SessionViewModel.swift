//
//  SessionViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/22/25.
//

import Foundation
import CoreData

class SessionViewModel: ObservableObject {
    
    let dataViewModel = DataViewModel()
    
    @Published var session: SessionData
    
    init(session: SessionData) {
        self.session = session
    }
    
    func deleteSession(context: NSManagedObjectContext, session: SessionData) {
        let success = dataViewModel.deleteSession(context: context, session: session)
    }
    
    func fetchSession(context: NSManagedObjectContext) {
        if let fetched = dataViewModel.fetchSession(context: context, session: session) {
            session = fetched
        }
    }
}
