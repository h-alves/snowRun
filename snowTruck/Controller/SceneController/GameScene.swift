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
    
    // MARK: - Scene Variables
    
    var targetPosition: CGPoint?
    var objectFactory: ObjectFactory!
    
    // MARK: Entity Nodes
    
    var truck: TruckNode!
    var landslide: LandslideNode!
    
    // MARK: UI Nodes
    
    var minute: Int = 0
    
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
        
        physicsWorld.contactDelegate = self
        
        objectFactory = ObjectFactory(offset: (frame.height/1.1))
        
        objectFactory.start(self)
        addChild(objectFactory)
        
        truck.consumeGas()
    }
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        let truckLocation = convert(touchLocation, to: truck)
        targetPosition = CGPoint(x: truck.position.x, y: truckLocation.y)
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
            
            moveBackground()
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
        self.backgroundColor = .red
        
        for i in 0..<2 {
            let bg = SKSpriteNode(texture: SKTexture(imageNamed: "background"), size: frame.size)
            bg.position = CGPoint(x: self.frame.midX, y: CGFloat(i) * bg.size.height)
            bg.name = "background"
            bg.zPosition = 0
            self.addChild(bg)
        }
    }
    
    func moveBackground() {
        self.enumerateChildNodes(withName: "background") { (node, stop) in
            let actualMoveSpeed = CGFloat(-7.25)  // Use a mesma velocidade que o cone
            node.position.y += actualMoveSpeed

            // Se o fundo se mover completamente para fora da tela, reposicione
            if node.position.y < -node.frame.size.height {
                node.position.y += node.frame.size.height * 2
            }
        }
    }
    
    func setUpNodes() {
        truck = TruckNode(texture: SKTexture(imageNamed: "truck"), color: .black, size: CGSize(width: 140, height: 160))
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
    }
    
    // MARK: - Game Over functions
    
    func showGameOver() {
        Analytics.logEvent(AnalyticsEventLevelEnd, parameters: [
            "level_name" : "default" as NSObject
        ])
        
        NotificationCenter.default.post(name: Notification.Name("ShowGameOver"), object: nil)
    }
    
    // MARK: - Update functions
    
    func updateDistance() {
        minute += 8
        if minute / 60 >= 1 {
            minute = 0
            controller.currentDistance += 1
            NotificationCenter.default.post(name: Notification.Name("DistanceLabelUpdated"), object: nil)
        }
    }
}
