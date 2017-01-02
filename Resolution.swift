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
    
    init(id: String, name: String, recurrence: String, frequency: Int64, notes: String) {
        self.id = id
        self.name = name
        self.recurrence = recurrence
        self.frequency = Int(frequency)
        self.notes = notes
    }
}
