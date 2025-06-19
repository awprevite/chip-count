//
//  SessionData.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import Foundation
import CoreData

struct SessionData: Identifiable {
    let name: String
    let id: UUID
    let date: Date
    let buyIn: Double
    let winnings: Double
    let duration: Int16
}

let mockData: [SessionData] = [
    SessionData(name: "one", id: UUID(), date: Date(), buyIn: 100.0, winnings: 120.0, duration: 60),
    SessionData(name: "two", id: UUID(), date: Date(), buyIn: 100.0, winnings: 0.0, duration: 60),
    SessionData(name: "three", id: UUID(), date: Date(), buyIn: 100.0, winnings: 200.0, duration: 60)
]
