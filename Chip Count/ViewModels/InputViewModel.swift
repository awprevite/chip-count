//
//  InputViewModel.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/16/25.
//

import CoreData
import Foundation

class InputViewModel: ObservableObject {
    
    init() {}
    
    @Published var date: Date = Date()
    @Published var buyIn: String = ""
    @Published var winnings: String = ""
    @Published var duration: String = ""
    @Published var hours = 0
    @Published var minutes = 0
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    var totalDuration: Int16 {
        Int16(hours * 60 + minutes)
    }
    
    func validateInputs() -> Bool {
        guard Double(buyIn) != nil, Double(winnings) != nil else {
            alertMessage = "Please enter valid amounts for Buy In Total and End Total"
            showAlert = true
            return false
        }
        
        if totalDuration == 0 {
            alertMessage = "Please enter a valid Duration time"
            showAlert = true
            return false
        }
        
        return true
    }
    
    func saveSession(context: NSManagedObjectContext, dismiss: () -> Void) {
        
        guard validateInputs(),
              let buyInValue = Double(buyIn),
              let winningsValue = Double(winnings)
        else { return }
        
        let newSession = Session(context: context)
        newSession.date = date
        newSession.buyIn = buyInValue
        newSession.winnings = winningsValue - buyInValue
        newSession.duration = totalDuration
        
        do {
            
            try context.save()
            reset()
            dismiss()
            
        } catch {
            alertMessage = "Failed to save sesson: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func reset() {
        buyIn = ""
        winnings = ""
        hours = 0
        minutes = 0
    }
}
