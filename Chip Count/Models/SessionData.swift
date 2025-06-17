//
//  SessionData.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import Foundation
import CoreData

struct SessionData: Identifiable {
    let id: NSManagedObjectID
    let date: Date
    let buyIn: Double
    let winnings: Double
    let duration: Int16
}
