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
    
    // MARK: - User Variables
    
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
    
    // MARK: - Scene Variables
    
    @Published var gameScene: GameScene!
    
    @Published var objectFactory: ObjectFactory!
    
    // MARK: Entity Nodes
    
    @Published var truck: TruckNode!
    @Published var landslide: LandslideNode!
    
    // MARK: UI Nodes
    
    @Published var distanceNode: TextNode!
    @Published var coinsNode: TextNode!
    
    
    // MARK: Menu Nodes
    
    @Published var overlayNode: SKShapeNode!
    @Published var gameOverLabel: SKLabelNode!
    @Published var restartButton: ButtonNode!
    @Published var menuButton: ButtonNode!
    
    // MARK: - Game Loop Variables
    
    @Published var gameIsOver: Bool = false
    @Published var holeCollision: Int = 0
    @Published var reduceTimer: Timer?
    
    // MARK: - Init
    
    private init() {
        self.highestDistance = 0.0
        self.totalCoins = 0
        retrieve()
    }
    
    // MARK: - User Defaults functions
    
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
    
    // MARK: - a
    
    
    
}
