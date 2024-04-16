//
//  Item.swift
//  ChatBot
//
//  Created by Daming Wang on 4/8/24.
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
