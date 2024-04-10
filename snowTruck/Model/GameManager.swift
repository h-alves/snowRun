//
//  GameManager.swift
//  snowTruck
//
//  Created by Henrique Semmer on 27/03/24.
//

import SpriteKit
import FirebaseAnalytics

class GameManager: ObservableObject {
    
    static let shared = GameManager()
    
    let defaults = UserDefaults.standard
    
    // MARK: - User Variables
    
    @Published var scene: GameScene!
    
    @Published var currentDistance = 0.0
    @Published var currentCoins = 0
    @Published var currentGas = 100
    
    @Published var currentObjects = [ObjectNode]()
    
    @Published var maxGas = 100
    
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
    
    // MARK: - Pause functions
    
    func pauseGame() {
        for object in currentObjects {
            object.isPaused = true
        }
        scene.truck.isPaused = true
        scene.landslide.isPaused = true
        scene.distanceNode.isPaused = true
        scene.coinsNode.isPaused = true
    }
    
    func resumeGame() {
        scene.view?.isPaused = false
    }
    
    // MARK: - Reset functions
    
    func resetEntities() {
        scene.truck.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - scene.truck.distance)
        scene.truck.isSpeedReduced = false
        scene.truck.gas = 100
        scene.truck.holes = 0
        
        scene.landslide.position = CGPoint(x: scene.frame.midX, y: scene.frame.minY - scene.landslide.landslideDistance)
        scene.landslide.removeAllActions()
    }
    
    func resetVariables() {
        scene.gameOverCard.isHidden = true
        scene.overlayNode.isHidden = true
        scene.restartButton.isHidden = true
        scene.menuButton.isHidden = true
        
        currentCoins = 0
        currentDistance = 0
        
        scene.gameIsOver = false
    }
    
    func resetObstacles() {
        for obstacle in currentObjects {
            obstacle.removeAllActions()
            obstacle.removeFromParent()
        }
        
        currentObjects = [ObstacleNode]()
        
        scene.objectFactory.start(scene)
    }
    
    func restartGame() {
        Analytics.logEvent("restart_level", parameters: [
            "level_name" : "default" as NSObject
        ])
        
        resetVariables()
        resetEntities()
        resetObstacles()
    }
    
}
