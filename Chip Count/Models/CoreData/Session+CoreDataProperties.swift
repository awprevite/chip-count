//
//  Session+CoreDataProperties.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/26/25.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var location: String?
    @NSManaged public var city: String?
    @NSManaged public var locationType: String?
    @NSManaged public var smallBlind: Double
    @NSManaged public var bigBlind: Double
    @NSManaged public var buyIn: Double
    @NSManaged public var cashOut: Double
    @NSManaged public var rebuys: Int32
    @NSManaged public var players: Int32
    @NSManaged public var badBeats: Int32
    @NSManaged public var mood: Int32
    @NSManaged public var notes: String?
    @NSManaged public var day: String?
    @NSManaged public var month: String?
    @NSManaged public var year: String?
    @NSManaged public var profit: Double
    @NSManaged public var roi: Double
    @NSManaged public var duration: Int32

}

extension Session : Identifiable {

}
