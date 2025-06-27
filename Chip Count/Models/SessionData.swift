//
//  SessionData.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import Foundation
import CoreData

extension DateFormatter {
    static let weekday: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return f
    }()

    static let month: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM"
        return f
    }()

    static let year: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy"
        return f
    }()
}


struct SessionData: Identifiable {
    let id: UUID
    
    let startTime: Date
    let endTime: Date
    let location: String
    let city: String
    let locationType: String// Home, Casino, Online
    let smallBlind: Double
    let bigBlind: Double
    let buyIn: Double
    let cashOut: Double     // was winnings
    let rebuys: Int
    let players: Int
    let badBeats: Int
    let mood: Int           // 1-5 satisfaction, add help button on each with a description
    let notes: String
    
    var day: String {
        DateFormatter.weekday.string(from: startTime)
    }

    var month: String {
        DateFormatter.month.string(from: startTime)
    }

    var year: String {
        DateFormatter.year.string(from: startTime)
    }

    var profit: Double {
        cashOut - buyIn
    }

    var roi: Double {
        guard buyIn != 0 else { return 0 }
        return (profit / buyIn) * 100
    }

    var duration: Int {
        Int(endTime.timeIntervalSince(startTime) / 60)
    }
}

let inputDescriptions: [String: String] = [
    "Help": "For more information on each field, tap the labels on the left.",
    "Start Time": "The date and time the session began.",
    "End Time": "The date and time the session ended.",
    "Location": "The place, building, or venue where the session was held or played from.",
    "City": "The city where the session was held or played from.",
    "Location Type": "The type of location where the session took place (Home, Casino, Online).",
    "Small Blind": "The value of the small blind during the session.",
    "Big Blind": "The value of the big blind during the session.",
    "Buy In": "The total amount of money spent while playing the game, including initial buy-ins, rebuys, and add-ons.",
    "Cash Out": "The amount of money you walked away with at the end of the session.",
    "roi": "Return on Investment, calculated as (Profit ÷ Buy-In) × 100.",
    "Rebuys": "The number of times you rebought into the game.",
    "Players": "The average number of players who participated in the session at a time.",
    "Bad Beats": "How many times you experienced a 'bad beat' — losing a strong hand to an unlikely outcome.",
    "Mood": "Your general feeling about the session on a scale of 1 (worst) to 5 (best).",
    "Notes": "Any extra details or thoughts you’d like to remember about the session.",
    
    "Time Error": "Please enter an End Time and a Start Time that is before the End Time.",
    "Long Time Error": "Session duration cannot exceed 48 hours.",
    "Money Error": "Please enter valid amounts for Buy In and Cash Out."
]

let mockData: [SessionData] = {
    let calendar = Calendar.current
    let now = Date()

    return [
        SessionData(
            id: UUID(),
            startTime: now,
            endTime: calendar.date(byAdding: .minute, value: 180, to: now)!,
            location: "Home",
            city: "Andover",
            locationType: "Home",
            smallBlind: 1.0,
            bigBlind: 2.0,
            buyIn: 100.0,
            cashOut: 180.0,
            rebuys: 1,
            players: 6,
            badBeats: 2,
            mood: 4,
            notes: ""
        ),
        SessionData(
            id: UUID(),
            startTime: calendar.date(byAdding: .day, value: -5, to: now)!,
            endTime: calendar.date(byAdding: .minute, value: 240, to: calendar.date(byAdding: .day, value: -5, to: now)!)!,
            location: "Casino Royale",
            city: "Vegas",
            locationType: "Casino",
            smallBlind: 2.0,
            bigBlind: 5.0,
            buyIn: 200.0,
            cashOut: 150.0,
            rebuys: 0,
            players: 8,
            badBeats: 3,
            mood: 2,
            notes: "Mad"
        ),
        SessionData(
            id: UUID(),
            startTime: calendar.date(byAdding: .day, value: -2, to: now)!,
            endTime: calendar.date(byAdding: .minute, value: 120, to: calendar.date(byAdding: .day, value: -2, to: now)!)!,
            location: "PokerStars",
            city: "Boston",
            locationType: "Online",
            smallBlind: 0.5,
            bigBlind: 1.0,
            buyIn: 50.0,
            cashOut: 90.0,
            rebuys: 0,
            players: 5,
            badBeats: 0,
            mood: 5,
            notes: "..."
        )
    ]
}()
