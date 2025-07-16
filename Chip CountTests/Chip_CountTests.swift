//
//  Chip_CountTests.swift
//  Chip CountTests
//
//  Created by Anthony Previte on 6/5/25.
//

import Testing
import CoreData
@testable import Chip_Count

extension NSPersistentContainer {
    static func inMemoryPersistentContainer() -> NSPersistentContainer {
        guard let modelURL = Bundle.main.url(forResource: "Chip_Count", withExtension: "momd") else {
            fatalError("Failed to find model URL for Chip_Count.momd")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create managed object model from URL: \(modelURL)")
        }

        let container = NSPersistentContainer(name: "Chip_Count", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null") // In-memory store
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }
}

struct Chip_CountTests {
    
    // DataViewModel
        
    var sut: DataViewModel!
    var mockPersistentContainer: NSPersistentContainer!
    var mockContext: NSManagedObjectContext!
    
    init() {
        mockPersistentContainer = .inMemoryPersistentContainer()
        mockContext = mockPersistentContainer.viewContext
        sut = DataViewModel()
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Session.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try mockContext.execute(deleteRequest)
            try mockContext.save()
        } catch {
            print("Failed to clear test data in init: \(error)")
        }
    }
    
    @Test func fetchAllSessions_ReturnsNoSessions() async throws {
        
        let sessions = try await mockContext.perform {
            self.sut.fetchAllSessions(context: self.mockContext)
        }
        #expect(sessions?.count == 0)
    }

}
