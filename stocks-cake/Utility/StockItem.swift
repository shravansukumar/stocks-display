//
//  StockItem.swift
//  stocks-cake
//
//  Created by Shravan Sukumar on 20/02/18.
//  Copyright © 2018 shravan. All rights reserved.
//

import Foundation

class StockItem {
    var timeStamp: Date!
    var open: Double!
    var high: Double!
    var low: Double!
    var close: Double!
    var volume: Double!
    
    init(timeStamp: Date, open: Double, high: Double, low: Double, close: Double,volume: Double) {
        self.timeStamp = timeStamp
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
    }
}
