//
//  SessionData.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import Foundation
import CoreData

struct SessionData: Identifiable {
    let id: UUID
    let date: Date
    let day: String // auto
    let location: String
    let city: String
    let locationType: String // Home, Casino, Online
    let smallBlind: Double
    let bigBlind: Double
    let buyIn: Double
    let cashOut: Double // was winnings
    let rebuys: Int
    let profit: Double // auto cashOut - buyIn
    let duration: Int // was Int16 represents total minutes
    let players: Int
    let badBeats: Int
    let mood: Int // 1-5 satisfaction, add help button on each with a description
    let notes: String
}

let inputDescriptions: [String: String] = [
    "Date": "The date the session began on.",
    "Location": "The place, building, or venue where the session was held or played from.",
    "City": "The city where the session was held or played from.",
    "Location Type": "The type of location where the session took place",
    "Small Blind": "The value of the small blind during the session.",
    "Big Blind": "The value of the big blind during the session.",
    "Buy In": "The total amount of money spent while playing the game, including initial buy-ins, re-buys, and add-ons.",
    "Cash Out": "The amount of money you walked away with at the end of the session.",
    "Rebuys": "The number of times you rebought into the game.",
    "Duration": "How long the session lasted.",
    "Players": "The average number of players who participated in the session at a time.",
    "Bad Beats": "How many times you experienced a 'bad beat' — losing a strong hand to an unlikely outcome, or losing a hand when you were confident you were going to win.",
    "Mood": "Your general feeling about the session on a scale of 1 (worst) to 5 (best).",
    "Notes": "Any extra details or thoughts you’d like to remember about the session."
]

let mockData: [SessionData] = [
    SessionData(
        id: UUID(),
        date: Date(),
        day: "Friday",
        location: "Home Game",
        city: "Andover",
        locationType: "Home",
        smallBlind: 1.0,
        bigBlind: 2.0,
        buyIn: 100.0,
        cashOut: 180.0,
        rebuys: 1,
        profit: 80.0,
        duration: 180,
        players: 6,
        badBeats: 2,
        mood: 4,
        notes: ""
    ),
    SessionData(
        id: UUID(),
        date: Date(),
        day: "Saturday",
        location: "Casino Royale",
        city: "Vegas",
        locationType: "Casino",
        smallBlind: 2.0,
        bigBlind: 5.0,
        buyIn: 200.0,
        cashOut: 150.0,
        rebuys: 0,
        profit: -50.0,
        duration: 240,
        players: 8,
        badBeats: 3,
        mood: 2,
        notes: "Mad"
    ),
    SessionData(
        id: UUID(),
        date: Date(),
        day: "Sunday",
        location: "PokerStars",
        city: "Boston",
        locationType: "Online",
        smallBlind: 0.5,
        bigBlind: 1.0,
        buyIn: 50.0,
        cashOut: 90.0,
        rebuys: 0,
        profit: 40.0,
        duration: 120,
        players: 5,
        badBeats: 0,
        mood: 5,
        notes: "..."
    )
]

