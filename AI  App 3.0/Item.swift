//
//  Item.swift
//  AI  App 3.0
//
//  Created by Isa Muniz on 6/4/25.
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
