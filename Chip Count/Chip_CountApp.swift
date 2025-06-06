//
//  Chip_CountApp.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import SwiftUI

@main
struct Chip_CountApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
