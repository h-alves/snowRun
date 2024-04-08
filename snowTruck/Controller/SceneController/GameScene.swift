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
    
    var targetPosition: CGPoint?
    
    // MARK: - SKScene Functions
    
    override func didMove(to view: SKView) {
        Analytics.logEvent(AnalyticsEventLevelStart, parameters: [
            "level_name" : "default" as NSObject
        ])
        controller.gameScene = self
        
        setUpBackground()
        setUpNodes()
        
        setUpGameOver()
        
        physicsWorld.contactDelegate = self
        
        controller.objectFactory = ObjectFactory(offset: (frame.height/1.1))
        controller.objectFactory.start(self)
        addChild(controller.objectFactory)
    }
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if controller.gameIsOver {
            if controller.restartButton.contains(touchLocation) {
                controller.restartGame()
            } else if controller.menuButton.contains(touchLocation) {
                controller.currentCoins = 0
                controller.currentDistance = 0
                
                goBack!()
            }
        } else {
            let truckLocation = convert(touchLocation, to: controller.truck)
            targetPosition = CGPoint(x: controller.truck.position.x, y: truckLocation.y)
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
        
        if !controller.gameIsOver {
            controller.truck.move(targetPosition: targetPosition ?? nil)
            controller.updateDistance()
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
        controller.truck = TruckNode(texture: SKTexture(imageNamed: "truck"), color: .black, size: CGSize(width: 80, height: 160))
        controller.truck.distance = (frame.height/3.4)
        controller.truck.position = CGPoint(x: frame.midX, y: frame.midY - controller.truck.distance)
        controller.truck.zPosition = 2.1
        controller.truck.delegate = self
        
        addChild(controller.truck)
        
        controller.landslide = LandslideNode(texture: SKTexture(imageNamed: "landslide"), size: CGSize(width: frame.width, height: frame.height + 100), frame: frame)
        controller.landslide.position = CGPoint(x: frame.midX, y: frame.minY - controller.landslide.landslideDistance)
        controller.landslide.zPosition = 2.2
        controller.landslide.delegate = self
        controller.landslide.secondaryAction = {
            self.controller.truck.isSpeedReduced = false
            self.controller.truck.holes = 0
        }
        
        addChild(controller.landslide)
        
        controller.distanceNode = TextNode(texture: SKTexture(imageNamed: "backgroundLabel"), size: CGSize(width: 250, height: 60), text: "0 km", color: .yellow)
        controller.distanceNode.position = CGPoint(x: frame.maxX * 0.75 - controller.distanceNode.size.width / 2, y: frame.maxY - controller.distanceNode.frame.height * 2.5)
        controller.distanceNode.zPosition = 2.3
        
        addChild(controller.distanceNode)
        
        controller.coinsNode = TextNode(texture: SKTexture(imageNamed: "backgroundLabel"), size: CGSize(width: 250, height: 60), text: "0", color: .yellow, secondaryTexture: SKTexture(imageNamed: "coin"), hasLabel: true)
        controller.coinsNode.position = CGPoint(x: frame.maxX * 0.75 - controller.distanceNode.size.width / 2, y: frame.maxY - controller.coinsNode.frame.height * 4)
        controller.coinsNode.zPosition = 2.3
        
        addChild(controller.coinsNode)
    }
    
    func setUpGameOver() {
        controller.overlayNode = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        controller.overlayNode.position = CGPoint(x: frame.midX, y: frame.midY)
        controller.overlayNode.fillColor = UIColor.black
        controller.overlayNode.alpha = 0.5
        controller.overlayNode.zPosition = 3
        controller.overlayNode.isHidden = true
        self.addChild(controller.overlayNode)
        
        controller.gameOverCard = SKSpriteNode(texture: SKTexture(imageNamed: "gameOver"), size: CGSize(width: frame.width * 0.75, height: frame.width * 0.55))
        controller.gameOverCard.position = CGPoint(x: frame.midX, y: frame.midY + frame.height * 0.07)
        controller.gameOverCard.alpha = 2.0
        controller.gameOverCard.zPosition = 3
        controller.gameOverCard.isHidden = true
        self.addChild(controller.gameOverCard)
        
        controller.restartButton = ButtonNode(size: CGSize(width: 200, height: 70), text: "restart", color: .yellow)
        controller.restartButton.position = CGPoint(x: frame.midX, y: frame.minY + frame.height * 0.22)
        controller.restartButton.zPosition = 3
        controller.restartButton.isHidden = true
        self.addChild(controller.restartButton)
        
        controller.menuButton = ButtonNode(size: CGSize(width: 140, height: 70), text: "menu", color: .yellow)
        controller.menuButton.position = CGPoint(x: frame.midX, y: frame.minY + frame.height * 0.15)
        controller.menuButton.zPosition = 3
        controller.menuButton.isHidden = true
        self.addChild(controller.menuButton)
    }
}
