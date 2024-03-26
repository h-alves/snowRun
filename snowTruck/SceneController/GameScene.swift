//
//  GameScene.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, PlayerContactDelegate, ObstacleContactDelegate {
    
    // MARK: - Objects
    
    var truck: TruckNode!
    var truckDistance: CGFloat = 0
    var landslide: LandslideNode!
    
    var targetPosition: CGPoint?
    
    // MARK: - Obstacle Generation
    
    var obstacleFactory: ObstacleFactory!
    var obstacleGenerationTimer: Timer?
    let obstacleGenerationInterval: TimeInterval = 2.0
    var obstacleList: [ObstacleNode] = [ObstacleNode]()
    
    // MARK: - Reset Screen
    
    var overlayNode: SKShapeNode!
    var gameOverLabel: SKLabelNode!
    var restartButton: RestartButtonNode!
    
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
        
        startObstacleGenerationTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: UIApplication
    
    @objc func enterBackground() {
        obstacleGenerationTimer?.invalidate()
        obstacleGenerationTimer = nil
    }
    
    @objc func enterForeground() {
        startObstacleGenerationTimer()
    }
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if restartButton.contains(touchLocation) {
            restartGame()
        }
        else {
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
        obstacleFactory = ObstacleFactory(frame: frame, offset: (frame.height/1.1))
        
        truck = TruckNode(size: CGSize(width: 80, height: 160), color: .red)
        truck.position = CGPoint(x: frame.midX, y: frame.midY - truckDistance)
        truck.zPosition = 2
        truck.delegate = self
        
        landslide = LandslideNode(size: CGSize(width: frame.width, height: frame.height + 100), frame: frame)
        landslide.position = CGPoint(x: frame.midX, y: frame.minY - landslide.landslideDistance)
        landslide.zPosition = 2.1
        landslide.delegate = self
        
        addChild(truck)
        addChild(landslide)
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
        
        restartButton = RestartButtonNode(size: CGSize(width: 200, height: 50), text: "restart", color: .yellow)
        restartButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        restartButton.zPosition = 3
        restartButton.isHidden = true
        self.addChild(restartButton)
    }
    
    // MARK: - Obstacle Generation Functions
    
    func startObstacleGenerationTimer() {
        obstacleGenerationTimer = Timer.scheduledTimer(timeInterval: obstacleGenerationInterval, target: self, selector: #selector(generateObstacle), userInfo: nil, repeats: true)
    }
    
    @objc func generateObstacle() {
        let child = obstacleFactory.createRandomObstacle()
        
        addChild(child)
        
        print("\(child) adicionado na posição: x = \(child.position.x) & y = \(child.position.y)")
        
        child.moveDown(finalSpace: frame.minY - 100)
        obstacleList.append(child)
    }
    
    // MARK: - Restart Game Functions
    
    func restartGame() {
        resetVariables()
        
        resetPositions()
        
        resetObstacles()
        
        obstacleGenerationTimer = Timer.scheduledTimer(timeInterval: obstacleGenerationInterval, target: self, selector: #selector(generateObstacle), userInfo: nil, repeats: true)
    }
    
    func resetPositions() {
        truck.position = CGPoint(x: frame.midX, y: frame.midY - truckDistance)
        landslide.position = CGPoint(x: frame.midX, y: frame.minY - landslide.landslideDistance)
    }
    
    func resetVariables() {
        gameOverLabel.isHidden = true
        overlayNode.isHidden = true
        restartButton.isHidden = true
        truck.isSpeedReduced = false
        holeCollision = 0
        gameIsOver = false
    }
    
    func changeToGameOverScene() {
        overlayNode.isHidden = false
        gameOverLabel.isHidden = false
        restartButton.isHidden = false
    }
    
    func resetObstacles() {
        for obstacle in obstacleList {
            obstacle.removeAllActions()
            obstacle.removeFromParent()
        }
        
        obstacleList = [ObstacleNode]()
    }
    
    // MARK: - Delegates
    
    // MARK: Player
    
    func gameOver() {
        if gameIsOver == false {
            // Parar de mover a tela pra baixo
            for obstacle in obstacleList {
                obstacle.removeAllActions()
            }
            
            gameIsOver = true
            changeToGameOverScene()
            obstacleGenerationTimer?.invalidate()
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
    
    // MARK: Landslide
    
    func deleteObstacle(obstacle: SKShapeNode) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Remover obstáculo da tela
            if self.obstacleList.count > 0 {
                self.obstacleList.removeFirst()
                obstacle.removeFromParent()
            }
            
            print("\(obstacle) foi apagado")
        }
    }
    
}

// MARK: - Delegate Protocols

protocol PlayerContactDelegate: AnyObject {
    func gameOver()
    func moveLandslideUp()
    func reduceSpeed()
}

protocol ObstacleContactDelegate: AnyObject {
    func deleteObstacle(obstacle: SKShapeNode)
}
