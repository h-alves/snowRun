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
    
    let controller = GameController.shared
    
    var goBack: (() -> Void)?
    
    // MARK: - Objects
    
    var truck: TruckNode!
    var landslide: LandslideNode!
    
    var targetPosition: CGPoint?
    
    var objectFactory: ObjectFactory!
    
    var distanceNode: TextNode!
    var coinsNode: TextNode!
    
    // MARK: - Reset Screen
    
    var overlayNode: SKShapeNode!
    var gameOverCard: SKSpriteNode!
    var restartButton: ButtonNode!
    var menuButton: ButtonNode!
    
    // MARK: - Gas
    
//    var gasBar: GasBarNode!
    
    // MARK: - Delegate Variables
    
    var gameIsOver: Bool = false
    var holeCollision: Int = 0
    var reduceTimer: Timer?
    
    // MARK: - SKScene Functions
    
    override func didMove(to view: SKView) {
        Analytics.logEvent(AnalyticsEventLevelStart, parameters: [
            "level_name" : "default" as NSObject
        ])
        
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
        
        if overlayNode.isHidden {
            let truckLocation = convert(touchLocation, to: truck)
            targetPosition = CGPoint(x: truck.position.x, y: truckLocation.y)
        } else {
            if restartButton.contains(touchLocation) {
                restartGame()
            } else if menuButton.contains(touchLocation) {
                controller.currentCoins = 0
                controller.currentDistance = 0
                
                goBack!()
            }
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
        truck.zPosition = 2
        truck.delegate = self
        
        addChild(truck)
        
        landslide = LandslideNode(texture: SKTexture(imageNamed: "landslide"), size: CGSize(width: frame.width, height: frame.height + 100), frame: frame)
        landslide.position = CGPoint(x: frame.midX, y: frame.minY - landslide.landslideDistance)
        landslide.zPosition = 2.1
        landslide.delegate = self
        landslide.secondaryAction = {
            self.truck.isSpeedReduced = false
            self.holeCollision = 0
        }
        
        addChild(landslide)
        
//        gasBar = GasBarNode(size: CGSize(width: 30, height: frame.height - 300))
//        gasBar.position = CGPoint(x: frame.maxX - gasBar.size.width * 3, y: frame.midY)
//        gasBar.fillColor = .green
//        gasBar.zPosition = 2
//        gasBar.decreaseFunc = {
//            self.truck.gas -= 10
//            if self.truck.gas < 0 {
//                self.truck.gas = 0
//                self.gameOver()
//                self.landslide.move(direction: .up)
//            }
//            self.gasBar.totalGas = self.truck.gas
//        }
//        gasBar.start(frame: self.frame)
//        
//        addChild(gasBar)
        
        distanceNode = TextNode(texture: SKTexture(imageNamed: "backgroundLabel"), size: CGSize(width: 250, height: 60), text: "0 km", color: .yellow)
        distanceNode.position = CGPoint(x: frame.maxX * 0.75 - distanceNode.size.width / 2, y: frame.maxY - distanceNode.frame.height * 2.5)
        distanceNode.zPosition = 2.2
        
        addChild(distanceNode)
        
        coinsNode = TextNode(texture: SKTexture(imageNamed: "backgroundLabel"), size: CGSize(width: 250, height: 60), text: "0", color: .yellow, secondaryTexture: SKTexture(imageNamed: "coin"), hasLabel: true)
        coinsNode.position = CGPoint(x: frame.maxX * 0.75 - distanceNode.size.width / 2, y: frame.maxY - coinsNode.frame.height * 4)
        coinsNode.zPosition = 2.2
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
    
    // MARK: - Restart Game Functions
    
    func pauseGame() {
        for object in controller.currentObjects {
            object.isPaused = true
        }
//        gasBar.isPaused = true
        truck.isPaused = true
        landslide.isPaused = true
        distanceNode.isPaused = true
        coinsNode.isPaused = true
    }
    
    func resumeGame() {
        self.view?.isPaused = false
    }
    
    func restartGame() {
        resetVariables()
        
        resetPositions()
        
        resetObstacles()
    }
    
    func resetPositions() {
        truck.position = CGPoint(x: frame.midX, y: frame.midY - truck.distance)
        landslide.removeAllActions()
        landslide.position = CGPoint(x: frame.midX, y: frame.minY - landslide.landslideDistance)
    }
    
    func resetVariables() {
        gameOverCard.isHidden = true
        overlayNode.isHidden = true
        restartButton.isHidden = true
        menuButton.isHidden = true
        truck.isSpeedReduced = false
        truck.gas = 100
        holeCollision = 0
        gameIsOver = false
        controller.currentCoins = 0
        controller.currentDistance = 0
//        gasBar = GasBarNode(size: CGSize(width: 30, height: frame.height - 300))
//        gasBar.position = CGPoint(x: frame.maxX - gasBar.size.width * 3, y: frame.midY)
//        gasBar.fillColor = .green
//        gasBar.zPosition = 2
//        gasBar.decreaseFunc = {
//            self.truck.gas -= 10
//            if self.truck.gas < 0 {
//                self.truck.gas = 0
//                self.gameOver()
//                self.landslide.move(direction: .up)
//            }
//            self.gasBar.totalGas = self.truck.gas
//        }
//        gasBar.start(frame: self.frame)
    }
    
    func changeToGameOverScene() {
        overlayNode.isHidden = false
        gameOverCard.isHidden = false
        restartButton.isHidden = false
        menuButton.isHidden = false
    }
    
    func resetObstacles() {
        for obstacle in controller.currentObjects {
            obstacle.removeAllActions()
            obstacle.removeFromParent()
        }
        
        controller.currentObjects = [ObstacleNode]()
        
        objectFactory.start(self)
    }
    
    func updateDistance() {
        controller.currentDistance += 0.1
        distanceNode.label.text = "\(Int(controller.currentDistance)) km"
    }
    
}

// MARK: - Delegates

extension GameScene: PlayerContactDelegate {
    
    func gameOver() {
        if gameIsOver == false {
            // Parar de mover a tela pra baixo
            for obstacle in controller.currentObjects {
                obstacle.removeAllActions()
            }
            
            gameIsOver = true
            changeToGameOverScene()
            
            objectFactory.stop()
//            gasBar.stop()
            
            controller.totalCoins += controller.currentCoins
            print("total de moedas: \(controller.totalCoins)")
            
            if controller.currentDistance > controller.highestDistance {
                controller.highestDistance = controller.currentDistance
                GameService.shared.submitScore(Int(controller.highestDistance), ids: ["highscore"]) {}
            }
        }
    }
    
    func reduceSpeed() {
        reduceTimer?.invalidate()
        holeCollision += 1
        print(holeCollision)
        
        self.sceneShake(shakeCount: 3, intensity: CGVector(dx: 4, dy: 1), shakeDuration: 0.2)
        HapticsService.shared.play(.heavy)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.truck.isSpeedReduced = true
            
            if self.holeCollision == 1 {
                // Mover avalanche pra colar com o caminhão
                self.landslide.move(direction: .close)
            } else if self.holeCollision == 2 {
                // Mover avalanche pra cima
                self.landslide.removeAllActions()
                
                self.landslide.move(direction: .up)
            }
        }
    }
    
    func moveLandslideUp() {
        // Mover avalanche pra cima
        landslide.removeAllActions()
        landslide.move(direction: .up)
    }
    
    func addGas(object: ObjectNode) {
//        gasIncrease = true
        truck.gas += 20
        if truck.gas > 100 {
            truck.gas = 100
        }
        
//        gasBar.addGas(truckGas: truck.gas, frame: self.frame)
        
        print(truck.gas)
        
        deleteItem(item: object)
    }
    
    func addCoin(object: ObjectNode) {
        controller.currentCoins += 1
        print(controller.currentCoins)
        
        deleteItem(item: object)
        
        coinsNode.label.text = "\(controller.currentCoins)"
    }
    
    func deleteItem(item: ObjectNode) {
        controller.currentObjects.removeAll { $0.id == item.id }
        item.removeFromParent()
    }
    
}

extension GameScene: ObjectContactDelegate {
    
    func deleteObject(object: ObjectNode) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Remover obstáculo da tela
            object.removeFromParent()
            self.controller.currentObjects.removeAll { $0.id == object.id }
        }
    }
    
    func deleteOnPosition(objectA: ObjectNode, objectB: ObjectNode) {
        print("ObjectA: \(objectA) ObjectB: \(objectB)")
        objectB.removeFromParent()
        self.controller.currentObjects.removeAll { $0.id == objectB.id }
    }
    
}
