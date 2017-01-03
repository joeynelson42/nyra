//
//  Resolution.swift
//  NYRA
//
//  Created by Joey on 1/2/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import Foundation

struct Resolution {
    var id = ""
    var name = ""
    var recurrence = ""
    var frequency = 0
    var notes = ""
    var current = 0
    
    init() {
        id = ""
        name = ""
        recurrence = ""
        frequency = 0
        notes = ""
        current = 0
    }
    
    init(id: String, name: String, recurrence: String, frequency: Int64, notes: String, current: Int64) {
        self.id = id
        self.name = name
        self.recurrence = recurrence
        self.frequency = Int(frequency)
        self.notes = notes
        self.current = Int(current)
    }
    
    /// Returns the total number of times the action must be completed for the entire year
    func getTotalGoal() -> Int {
        switch recurrence {
        case "daily":
            return frequency * 365
        case "weekly":
            return frequency * 52
        case "monthly":
            return frequency * 12
        case "yearly":
            return frequency
        default:
            return 0
        }
    }
    
    /// Returns the number of times the action should have been completed relative to the current date
    func getLocalGoal() -> Int {
        let date = Date()
        let cal = Calendar.current
        
        switch recurrence {
        case "daily":
            guard let day = cal.ordinality(of: .day, in: .year, for: date) else { return 0 }
            return day * frequency
        case "weekly":
            guard let week = cal.ordinality(of: .weekOfYear, in: .year, for: date) else { return 0 }
            return week * frequency
        case "monthly":
            guard let month = cal.ordinality(of: .month, in: .year, for: date) else { return 0 }
            return month * frequency
        case "yearly":
            return frequency
        default:
            return 0
        }
    }
}
