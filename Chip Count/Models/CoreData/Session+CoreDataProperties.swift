//
//  Session+CoreDataProperties.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/6/25.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var buyIn: Double
    @NSManaged public var date: Date?
    @NSManaged public var duration: Int16
    @NSManaged public var winnings: Double

}

extension Session : Identifiable {

}
