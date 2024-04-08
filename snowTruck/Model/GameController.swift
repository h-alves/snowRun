//
//  GameController.swift
//  snowTruck
//
//  Created by Henrique Semmer on 27/03/24.
//

import SpriteKit
import FirebaseAnalytics

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
    @Published var gameOverCard: SKSpriteNode!
    @Published var restartButton: ButtonNode!
    @Published var menuButton: ButtonNode!
    
    // MARK: - Game Loop Variables
    
    @Published var gameIsOver: Bool = false
    
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
    
    // MARK: - Pause Game functions
    
    func pauseGame() {
        for object in currentObjects {
            object.isPaused = true
        }
        truck.isPaused = true
        landslide.isPaused = true
        distanceNode.isPaused = true
        coinsNode.isPaused = true
    }
    
    func resumeGame() {
        gameScene.view?.isPaused = false
    }
    
    // MARK: - Restart Game functions
    
    func resetEntities() {
        truck.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY - truck.distance)
        truck.isSpeedReduced = false
        truck.gas = 100
        truck.holes = 0
        
        landslide.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.minY - landslide.landslideDistance)
        landslide.removeAllActions()
    }
    
    func resetVariables() {
        gameOverCard.isHidden = true
        overlayNode.isHidden = true
        restartButton.isHidden = true
        menuButton.isHidden = true
        
        currentCoins = 0
        currentDistance = 0
        
        gameIsOver = false
    }
    
    func resetObstacles() {
        for obstacle in currentObjects {
            obstacle.removeAllActions()
            obstacle.removeFromParent()
        }
        
        currentObjects = [ObstacleNode]()
        
        objectFactory.start(gameScene)
    }
    
    func restartGame() {
        Analytics.logEvent("restart_level", parameters: [
            "level_name" : "default" as NSObject
        ])
        
        resetVariables()
        resetEntities()
        resetObstacles()
    }
    
    // MARK: - Game Over functions
    
    func showGameOver() {
        Analytics.logEvent(AnalyticsEventLevelEnd, parameters: [
            "level_name" : "default" as NSObject
        ])
        
        overlayNode.isHidden = false
        gameOverCard.isHidden = false
        restartButton.isHidden = false
        menuButton.isHidden = false
    }
    
    // MARK: - Update functions
    
    func updateDistance() {
        currentDistance += 0.1
        distanceNode.label.text = "\(Int(currentDistance)) km"
    }
    
}
