//
//  Item.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
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
