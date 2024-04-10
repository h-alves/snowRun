//
//  GameScene.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit
import GameplayKit
import FirebaseAnalytics

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let controller = GameManager.shared
    
    var goBack: (() -> Void)?
    
    // MARK: - Scene Variables
    
    var targetPosition: CGPoint?
    var objectFactory: ObjectFactory!
    
    // MARK: Entity Nodes
    
    var truck: TruckNode!
    var landslide: LandslideNode!
    
    // MARK: UI Nodes
    
    var distanceNode: TextNode!
    var coinsNode: TextNode!
    
    // MARK: Menu Nodes
    
    var overlayNode: SKShapeNode!
    var gameOverCard: SKSpriteNode!
    var restartButton: ButtonNode!
    var menuButton: ButtonNode!
    
    // MARK: - Game Loop Variables
    
    var gameIsOver: Bool = false
    
    // MARK: - SKScene Functions
    
    override func didMove(to view: SKView) {
        Analytics.logEvent(AnalyticsEventLevelStart, parameters: [
            "level_name" : "default" as NSObject
        ])
        
        controller.scene = self
        
        setUpBackground()
        setUpNodes()
        
        setUpGameOver()
        
        physicsWorld.contactDelegate = self
        
        objectFactory = ObjectFactory(offset: (frame.height/1.1))
        
        objectFactory.start(self)
        addChild(objectFactory)
    }
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if gameIsOver {
            if restartButton.contains(touchLocation) {
                controller.restartGame()
            } else if menuButton.contains(touchLocation) {
                goBack!()
            }
        } else {
            let truckLocation = convert(touchLocation, to: truck)
            targetPosition = CGPoint(x: truck.position.x, y: truckLocation.y)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        targetPosition = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        targetPosition = nil
    }
    
    // MARK: Update
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if !gameIsOver {
            truck.move(targetPosition: targetPosition ?? nil)
            updateDistance()
        }
    }
    
    // MARK: Collision
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nameA = contact.bodyA.node?.name
        let nameB = contact.bodyB.node?.name
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.player || contact.bodyB.categoryBitMask == PhysicsCategory.player {
            if let truckNode = contact.bodyA.node as? TruckNode {
                truckNode.beganContact(with: contact.bodyB.node!)
            } else if let truckNode = contact.bodyB.node as? TruckNode {
                truckNode.beganContact(with: contact.bodyA.node!)
            }
        } else if contact.bodyA.categoryBitMask == PhysicsCategory.landslide || contact.bodyB.categoryBitMask == PhysicsCategory.landslide {
            if let landslideNode = contact.bodyA.node as? LandslideNode {
                landslideNode.beganContact(with: contact.bodyB.node!)
            } else if let landslideNode = contact.bodyB.node as? LandslideNode {
                landslideNode.beganContact(with: contact.bodyA.node!)
            }
        } else if nameA == "block" || nameA == "hole" || nameA == "gas" || nameA == "coin" {
            if let objectA = contact.bodyA.node as? ObjectNode, let objectB = contact.bodyB.node as? ObjectNode {
                objectA.beganContact(with: objectB)
            }
        } else if nameB == "block" || nameB == "hole" || nameB == "gas" || nameB == "coin" {
            if let objectA = contact.bodyA.node as? ObjectNode, let objectB = contact.bodyB.node as? ObjectNode {
                objectB.beganContact(with: objectA)
            }
        }
    }
    
    // MARK: - Set Up Functions
    
    func setUpBackground() {
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "background"), size: frame.size)
        background.zPosition = 0
        addChild(background)
    }
    
    func setUpNodes() {
        truck = TruckNode(texture: SKTexture(imageNamed: "truck"), color: .black, size: CGSize(width: 80, height: 160))
        truck.distance = (frame.height/3.4)
        truck.position = CGPoint(x: frame.midX, y: frame.midY - truck.distance)
        truck.zPosition = 2.1
        truck.delegate = self
        
        addChild(truck)
        
        landslide = LandslideNode(texture: SKTexture(imageNamed: "landslide"), size: CGSize(width: frame.width, height: frame.height + 100), frame: frame)
        landslide.position = CGPoint(x: frame.midX, y: frame.minY - landslide.landslideDistance)
        landslide.zPosition = 2.2
        landslide.delegate = self
        landslide.secondaryAction = {
            self.truck.isSpeedReduced = false
            self.truck.holes = 0
        }
        
        addChild(landslide)
        
        distanceNode = TextNode(texture: SKTexture(imageNamed: "backgroundLabel"), size: CGSize(width: 250, height: 60), text: "0 km", color: .yellow)
        distanceNode.position = CGPoint(x: frame.maxX * 0.75 - distanceNode.size.width / 2, y: frame.maxY - distanceNode.frame.height * 2.5)
        distanceNode.zPosition = 2.3
        
        addChild(distanceNode)
        
        coinsNode = TextNode(texture: SKTexture(imageNamed: "backgroundLabel"), size: CGSize(width: 250, height: 60), text: "0", color: .yellow, secondaryTexture: SKTexture(imageNamed: "coin"), hasLabel: true)
        coinsNode.position = CGPoint(x: frame.maxX * 0.75 - distanceNode.size.width / 2, y: frame.maxY - coinsNode.frame.height * 4)
        coinsNode.zPosition = 2.3
        
        addChild(coinsNode)
    }
    
    func setUpGameOver() {
        overlayNode = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        overlayNode.position = CGPoint(x: frame.midX, y: frame.midY)
        overlayNode.fillColor = UIColor.black
        overlayNode.alpha = 0.5
        overlayNode.zPosition = 3
        overlayNode.isHidden = true
        self.addChild(overlayNode)
        
        gameOverCard = SKSpriteNode(texture: SKTexture(imageNamed: "gameOver"), size: CGSize(width: frame.width * 0.75, height: frame.width * 0.55))
        gameOverCard.position = CGPoint(x: frame.midX, y: frame.midY + frame.height * 0.07)
        gameOverCard.alpha = 2.0
        gameOverCard.zPosition = 3
        gameOverCard.isHidden = true
        self.addChild(gameOverCard)
        
        restartButton = ButtonNode(size: CGSize(width: 200, height: 70), text: "restart", color: .yellow)
        restartButton.position = CGPoint(x: frame.midX, y: frame.minY + frame.height * 0.22)
        restartButton.zPosition = 3
        restartButton.isHidden = true
        self.addChild(restartButton)
        
        menuButton = ButtonNode(size: CGSize(width: 140, height: 70), text: "menu", color: .yellow)
        menuButton.position = CGPoint(x: frame.midX, y: frame.minY + frame.height * 0.15)
        menuButton.zPosition = 3
        menuButton.isHidden = true
        self.addChild(menuButton)
    }
    
//    // MARK: - Pause Game functions
//    
//    func pauseGame() {
//        for object in controller.currentObjects {
//            object.isPaused = true
//        }
//        truck.isPaused = true
//        landslide.isPaused = true
//        distanceNode.isPaused = true
//        coinsNode.isPaused = true
//    }
//    
//    func resumeGame() {
//        self.view?.isPaused = false
//    }
//    
//    // MARK: - Restart Game functions
//    
//    func resetEntities() {
//        truck.position = CGPoint(x: frame.midX, y: frame.midY - truck.distance)
//        truck.isSpeedReduced = false
//        truck.gas = 100
//        truck.holes = 0
//        
//        landslide.position = CGPoint(x: frame.midX, y: frame.minY - landslide.landslideDistance)
//        landslide.removeAllActions()
//    }
//    
//    func resetVariables() {
//        gameOverCard.isHidden = true
//        overlayNode.isHidden = true
//        restartButton.isHidden = true
//        menuButton.isHidden = true
//        
//        controller.currentCoins = 0
//        controller.currentDistance = 0
//        
//        gameIsOver = false
//    }
//    
//    func resetObstacles() {
//        for obstacle in controller.currentObjects {
//            obstacle.removeAllActions()
//            obstacle.removeFromParent()
//        }
//        
//        controller.currentObjects = [ObstacleNode]()
//        
//        objectFactory.start(self)
//    }
//    
//    func restartGame() {
//        Analytics.logEvent("restart_level", parameters: [
//            "level_name" : "default" as NSObject
//        ])
//        
//        resetVariables()
//        resetEntities()
//        resetObstacles()
//    }
    
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
        controller.currentDistance += 0.1
        distanceNode.label.text = "\(Int(controller.currentDistance)) km"
    }
}
