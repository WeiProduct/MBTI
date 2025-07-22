//
//  Item.swift
//  AIMBTI
//
//  Created by weifu on 7/22/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
