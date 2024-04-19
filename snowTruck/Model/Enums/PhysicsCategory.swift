//
//  PhysicsCategory.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import Foundation

struct PhysicsCategory {
    static let none: UInt32 = 0
    
    // MARK: Important Nodes
    static let player: UInt32 = 0x1 << 0
    static let landslide: UInt32 = 0x1 << 1
    
    // MARK: Obstacles
    static let hole: UInt32 = 0x1 << 10
    static let block: UInt32 = 0x1 << 11
    
    // MARK: Items
    static let gas: UInt32 = 0x1 << 20
    static let coin: UInt32 = 0x1 << 21
    
    static let titleOne: UInt32 = 0x1 << 30
    static let titleTwo: UInt32 = 0x1 << 31
    static let emptyBlock: UInt32 = 0x1 << 32
}
