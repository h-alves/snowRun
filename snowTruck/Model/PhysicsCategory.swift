//
//  PhysicsCategory.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import Foundation

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0x1 << 0
    static let landslide: UInt32 = 0x1 << 1
}
