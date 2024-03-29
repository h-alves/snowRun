//
//  GameController.swift
//  snowTruck
//
//  Created by Henrique Semmer on 27/03/24.
//

import SpriteKit

class GameController: ObservableObject {
    
    static let shared = GameController()
    
    @Published var currentDistance = 0.0
    @Published var currentCoins = 0
    @Published var currentObjects = [ObjectNode]()
    
    @Published var highestDistance = 0.0
    @Published var totalCoins = 0
    
}
