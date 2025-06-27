//
//  PersistenceController.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/6/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load Core Data store: \(error)")
            }else {
                print(" Core Data store loaded: \(description)")
            }
        }
    }
}
