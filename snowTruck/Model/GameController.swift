//
//  GameController.swift
//  snowTruck
//
//  Created by Henrique Semmer on 27/03/24.
//

import SpriteKit

class GameController: ObservableObject {
    
    static let shared = GameController()
    
    let defaults = UserDefaults.standard
    
    @Published var currentDistance = 0.0
    @Published var currentCoins = 0
    @Published var currentObjects = [ObjectNode]()
    
    @Published var highestDistance: Double {
        didSet {
            if oldValue != highestDistance {
                saveDistance()
            }
        }
    }
    @Published var totalCoins: Int {
        didSet {
            if oldValue != totalCoins {
                saveCoins()
            }
        }
    }
    
    private init() {
        self.highestDistance = 0.0
        self.totalCoins = 0
        retrieve()
    }
    
    func saveDistance() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(highestDistance) {
            defaults.set(encoded, forKey: "highscore")
            print("saved \(highestDistance)")
        }
    }
    
    func saveCoins() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(totalCoins) {
            defaults.set(encoded, forKey: "coins")
            print("saved \(totalCoins)")
        }
    }
    
    func retrieve() {
        if let saved = defaults.object(forKey: "highscore") as? Data {
            print("saved")
            let decoder = JSONDecoder()
            
            do {
                let loaded = try decoder.decode(Double.self, from: saved)
                highestDistance = loaded
                print("retrieved \(highestDistance)")
            } catch {
                print(error)
            }
        }
        if let saved = defaults.object(forKey: "coins") as? Data {
            print("saved")
            let decoder = JSONDecoder()
            
            do {
                let loaded = try decoder.decode(Int.self, from: saved)
                totalCoins = loaded
                print("retrieved \(totalCoins)")
            } catch {
                print(error)
            }
        }
    }
    
}
