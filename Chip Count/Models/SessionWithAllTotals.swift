//
//  SessionWithAllTotals.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

// Holds latest session and the cumulative totals from all sessions incuding that one

import Foundation
import CoreData

struct SessionWithAllTotals: Identifiable {
    let id = UUID()
    let session: SessionData
    let runningMoney: Double
    let runningTime: Int16
}
