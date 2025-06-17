//
//  SessionWithAllTotals.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import Foundation
import CoreData

struct SessionWithAllTotals: Identifiable {
    let id = UUID()
    let session: SessionData
    let runningMoney: Double
    let runningTime: Int16
}
