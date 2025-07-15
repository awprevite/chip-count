//
//  DataViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 7/14/25.
//

import CoreData

class DataViewModel: ObservableObject {
    
    /// Fetch all sessions
    /// - Parameter context: The managed object context used to fetch sessions
    /// - Returns: An array of `SessionData` representing all saved sessions
    func fetchAllSessions(context: NSManagedObjectContext) -> [SessionData]? {
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Session.startTime, ascending: true)]

        do {
            let allSessions = try context.fetch(request)
            return allSessions.map { session in
                toSessionData(from: session)
            }
        } catch {
            print("Error fetching sessions: \(error)")
            return nil
        }
    }
    
    /// Fetch an individual session
    /// - Parameter context: The managed object context
    /// - Returns: `SessionData` representing the session
    func fetchSession(context: NSManagedObjectContext, session: SessionData) -> SessionData? {
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)
        request.fetchLimit = 1

        do {
            if let session = try context.fetch(request).first {
                
                return toSessionData(from: session)
                
            }
        } catch {
            print("Failed to fetch session: \(error)")
        }
        return nil
    }
    
    /// Inserts a session
    /// - Parameter context: The managed object context
    /// - Parameter session: The session to be saved
    /// - Returns: true if successful or false if unsuccessful
    func insertSession(context: NSManagedObjectContext, session: SessionData) -> Bool {
        
        do {
            
            let newSession = Session(context: context)
            newSession.update(from: session)
            
            try context.save()
            return true
            
        } catch {
            return false
        }
    }
    
    /// Updates a session
    /// - Parameter context: The managed object context used to fetch sessions
    /// - Parameter session: The session to be saved
    /// - Returns: true if successfully saved or false if unsuccessful
    func updateSession(context: NSManagedObjectContext, session: SessionData) -> Bool {
        
        do {

            let request: NSFetchRequest<Session> = Session.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)
            request.fetchLimit = 1
            
            if let existingSession = try context.fetch(request).first {
                
                existingSession.update(from: session)
                
                try context.save()
                return true
                
            } else {
                print("Could not find session to update")
                return false
            }
            
        } catch {
            return false
        }
    }
    
    
    /// Deletes a session
    /// - Parameter context: The managed object context
    /// - Parameter session: The session to be deleted
    /// - Returns: true if successful or false if unsuccessful
    func deleteSession(context: NSManagedObjectContext, session: SessionData) -> Bool {
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let sessionToDelete = results.first {
                context.delete(sessionToDelete)
                try context.save()
                print("Deleted session with id: \(session.id)")
                return true
            }
        } catch {
            print("Failed to delete session: \(error)")
            return false
        }
        
        return false
    }
}
