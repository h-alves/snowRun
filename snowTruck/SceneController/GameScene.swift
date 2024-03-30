//
//  GameScene.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Objects
    
    var truck: TruckNode!
    var truckDistance: CGFloat = 0
    var landslide: LandslideNode!
    
    var targetPosition: CGPoint?
    
    var objectFactory: ObjectFactory!
    
    // MARK: - Reset Screen
    
    var overlayNode: SKShapeNode!
    var gameOverLabel: SKLabelNode!
    var restartButton: ButtonNode!
    var menuButton: ButtonNode!
    
    // MARK: - Gas
    
    var gasTimer: Timer?
    let gasTimeInterval: TimeInterval = 2.0
    var gasBar: SKShapeNode!
    var gasIncrease: Bool = false
    
    // MARK: - Delegate Variables
    
    var gameIsOver: Bool = false
    var holeCollision: Int = 0
    var reduceTimer: Timer?
    
    // MARK: - SKScene Functions
    
    override func didMove(to view: SKView) {
        truckDistance = (frame.height/3.4)
        
        setUpBackground()
        setUpNodes()
        
        setUpGameOver()
        
        physicsWorld.contactDelegate = self
        
        objectFactory = ObjectFactory(offset: (frame.height/1.1))
        objectFactory.start(self)
        addChild(objectFactory)
        startGasTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: UIApplication
    
    @objc func enterBackground() {
        // Pause Game
        gasTimer?.invalidate()
        gasTimer = nil
    }
    
    @objc func enterForeground() {
        // Unpause Game
        startGasTimer()
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
                changeToMenuScene()
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
        }
    }
    
    // MARK: Collision
    
    func didBegin(_ contact: SKPhysicsContact) {
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
        }
    }
    
    // MARK: - Set Up Functions
    
    func setUpBackground() {
        backgroundColor = .gray
    }
    
    func setUpNodes() {
        truck = TruckNode(size: CGSize(width: 80, height: 160), color: .black)
        truck.position = CGPoint(x: frame.midX, y: frame.midY - truckDistance)
        truck.zPosition = 2
        truck.delegate = self
        
        landslide = LandslideNode(size: CGSize(width: frame.width, height: frame.height + 100), frame: frame)
        landslide.position = CGPoint(x: frame.midX, y: frame.minY - landslide.landslideDistance)
        landslide.zPosition = 2.1
        landslide.delegate = self
        
        addChild(truck)
        addChild(landslide)
        
        gasBar = SKShapeNode(path: CGPath(rect: CGRect(origin: CGPoint(x: -60, y: 0), size: CGSize(width: 60, height: frame.height - 300)), transform: nil))
        gasBar.position = CGPoint(x: frame.maxX - 120, y: frame.midY - (frame.height - 300) / 2)
        gasBar.fillColor = .green
        gasBar.zPosition = 2
        
        addChild(gasBar)
    }
    
    func setUpGameOver() {
        overlayNode = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        overlayNode.position = CGPoint(x: frame.midX, y: frame.midY)
        overlayNode.fillColor = UIColor.black
        overlayNode.alpha = 0.5
        overlayNode.zPosition = 3
        overlayNode.isHidden = true
        self.addChild(overlayNode)
        
        gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "Arial"
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.alpha = 2.0
        gameOverLabel.zPosition = 3
        gameOverLabel.isHidden = true
        self.addChild(gameOverLabel)
        
        restartButton = ButtonNode(size: CGSize(width: 200, height: 50), text: "restart", color: .yellow)
        restartButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        restartButton.zPosition = 3
        restartButton.isHidden = true
        self.addChild(restartButton)
        
        menuButton = ButtonNode(size: CGSize(width: 200, height: 50), text: "menu", color: .yellow)
        menuButton.position = CGPoint(x: frame.midX, y: frame.midY - 200)
        menuButton.zPosition = 3
        menuButton.isHidden = true
        self.addChild(menuButton)
    }
    
    // MARK: - Gas Going Down Functions
    
    func startGasTimer() {
        gasTimer = Timer.scheduledTimer(timeInterval: gasTimeInterval, target: self, selector: #selector(subtractGas), userInfo: nil, repeats: true)
    }
    
    @objc func subtractGas() {
        if !gasIncrease {
            truck.gas -= 10
            if truck.gas < 0 {
                truck.gas = 0
                gameOver()
                landslide.move(direction: .up)
            }
            print(truck.gas)
            
            let maxGasHeight = frame.height - 300
            let remainingGasHeight = maxGasHeight * CGFloat(truck.gas) / 100
            
            gasBar.path = CGPath(rect: CGRect(x: -60, y: 0, width: 60, height: remainingGasHeight), transform: nil)
            
        }
    }
    
    // MARK: - Restart Game Functions
    
    func restartGame() {
        resetVariables()
        
        resetPositions()
        
        resetObstacles()
    }
    
    func resetPositions() {
        truck.position = CGPoint(x: frame.midX, y: frame.midY - truckDistance)
        landslide.removeAllActions()
        landslide.position = CGPoint(x: frame.midX, y: frame.minY - landslide.landslideDistance)
        gasBar.path = CGPath(rect: CGRect(origin: CGPoint(x: -60, y: 0), size: CGSize(width: 60, height: frame.height - 300)), transform: nil)
    }
    
    func resetVariables() {
        gameOverLabel.isHidden = true
        overlayNode.isHidden = true
        restartButton.isHidden = true
        menuButton.isHidden = true
        truck.isSpeedReduced = false
        truck.gas = 100
        holeCollision = 0
        gameIsOver = false
        startGasTimer()
    }
    
    func changeToGameOverScene() {
        overlayNode.isHidden = false
        gameOverLabel.isHidden = false
        restartButton.isHidden = false
        menuButton.isHidden = false
    }
    
    func changeToMenuScene() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .aspectFill
        
        self.view?.presentScene(menuScene, transition: transition)
    }
    
    func resetObstacles() {
        for obstacle in GameController.shared.currentObjects {
            obstacle.removeAllActions()
            obstacle.removeFromParent()
        }
        
        GameController.shared.currentObjects = [ObstacleNode]()
        
        objectFactory.start(self)
    }
    
    
    
}

// MARK: - Delegates

extension GameScene: PlayerContactDelegate {
    
    func gameOver() {
        if gameIsOver == false {
            // Parar de mover a tela pra baixo
            for obstacle in GameController.shared.currentObjects {
                obstacle.removeAllActions()
            }
            
            gameIsOver = true
            changeToGameOverScene()
            
            objectFactory.stop()
            gasTimer?.invalidate()
        }
    }
    
    func reduceSpeed() {
        reduceTimer?.invalidate()
        holeCollision += 1
        print(holeCollision)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.truck.isSpeedReduced = true
            
            if self.holeCollision == 1 {
                // Mover avalanche pra colar com o caminhão
                self.landslide.move(direction: .close)
            } else if self.holeCollision == 2 {
                // Mover avalanche pra cima
                self.landslide.move(direction: .up)
            }
        }
        
        reduceTimer = Timer.scheduledTimer(withTimeInterval: 6.3, repeats: false) { timer in
            self.truck.isSpeedReduced = false
            
            if self.holeCollision < 2 && self.gameIsOver == false {
                self.holeCollision = 0
                
                // Mover avalanche pra baixo
                self.landslide.move(direction: .down)
                
                timer.invalidate()
            }
        }
    }
    
    func moveLandslideUp() {
        // Mover avalanche pra cima
        landslide.move(direction: .up)
    }
    
    func addGas(object: ObjectNode) {
        gasIncrease = true
        truck.gas += 20
        if truck.gas > 100 {
            truck.gas = 100
        }
        
        let maxGasHeight = frame.height - 300
        let remainingGasHeight = maxGasHeight * CGFloat(truck.gas) / 100
        
        gasBar.path = CGPath(rect: CGRect(x: -60, y: 0, width: 60, height: remainingGasHeight), transform: nil)
        
        print(truck.gas)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.gasIncrease = false
        }
        
        deleteItem(item: object)
    }
    
    func addCoin(object: ObjectNode) {
        GameController.shared.totalCoins += 1
        print(GameController.shared.totalCoins)
        
        deleteItem(item: object)
    }
    
    func deleteItem(item: ObjectNode) {
        GameController.shared.currentObjects.removeAll { $0.id == item.id }
        item.removeFromParent()
    }
    
}

extension GameScene: ObjectContactDelegate {
    
    func deleteObject(object: ObjectNode) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Remover obstáculo da tela
            if GameController.shared.currentObjects.count > 0 {
                GameController.shared.currentObjects.removeFirst()
                object.removeFromParent()
            }
            
            print("\(object) foi apagado")
        }
    }
    
}
