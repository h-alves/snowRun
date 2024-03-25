//
//  GameScene.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, PlayerContactDelegate {
    
    var truck: TruckNode!
    var landslide: LandslideNode!
    var targetPosition: CGPoint?
    
    var cameraNode: SKCameraNode!
    let cameraSpeed: CGFloat = 0.1
    var cameraDistance: CGFloat = 350
    
    var overlayNode: SKShapeNode!
    var gameOverLabel: SKLabelNode!
    var restartButton: RestartButtonNode!
    
    var gameIsOver: Bool = false
    var isSpeedReduced: Bool = false
    var secondPass: Bool = false
    
    override func didMove(to view: SKView) {
        setUpBackground()
        setUpCamera()
        setUpNodes()
        
        setUpGameOver()
        
        physicsWorld.contactDelegate = self
    }
    
    func setUpBackground() {
        backgroundColor = .gray
    }
    
    func setUpCamera() {
        cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        self.camera = cameraNode
        
        addChild(cameraNode)
    }
    
    func setUpNodes() {
        truck = TruckNode(size: CGSize(width: 100, height: 200), color: .red)
        truck.position = CGPoint(x: frame.midX, y: frame.midY)
        truck.delegate = self
        
        landslide = LandslideNode(size: CGSize(width: frame.width, height: frame.height + 100))
        landslide.position = CGPoint(x: frame.midX, y: frame.minY - 700)
        
        let block = LandslideNode(size: CGSize(width: 60, height: 60))
        block.fillColor = .blue
        block.position = CGPoint(x: frame.midX, y: 3000)
        
        let block1 = LandslideNode(size: CGSize(width: 60, height: 60))
        block1.fillColor = .blue
        block1.position = CGPoint(x: frame.midX, y: 1200)
        
        let block2 = LandslideNode(size: CGSize(width: 60, height: 60))
        block2.fillColor = .blue
        block2.position = CGPoint(x: frame.midX, y: 1800)
        
        let hole1 = HoleNode(size: CGSize(width: 70, height: 70))
        hole1.fillColor = .green
        hole1.position = CGPoint(x: frame.midX, y: 2400)
        
        let hole2 = HoleNode(size: CGSize(width: 70, height: 70))
        hole2.fillColor = .green
        hole2.position = CGPoint(x: frame.midX, y: 3000)
        
        addChild(hole1)
        addChild(hole2)
        addChild(truck)
//        addChild(block)
        addChild(block1)
        addChild(block2)
        addChild(landslide)
    }
    
    func setUpGameOver() {
        overlayNode = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        overlayNode.position = CGPoint(x: frame.midX, y: frame.midY)
        overlayNode.fillColor = UIColor.black
        overlayNode.alpha = 0.5
        overlayNode.zPosition = 1
        overlayNode.isHidden = true
        self.addChild(overlayNode)
        
        gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "Arial"
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.alpha = 2.0
        gameOverLabel.zPosition = 1
        gameOverLabel.isHidden = true
        self.addChild(gameOverLabel)
        
        restartButton = RestartButtonNode(size: CGSize(width: 200, height: 50), text: "restart", color: .yellow)
        restartButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        restartButton.zPosition = 1
        restartButton.isHidden = true
        self.addChild(restartButton)
    }
    
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
    
    func restartGame() {
        resetVariables()
        
        resetPositions()
    }
    
    func resetPositions() {
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        truck.position = CGPoint(x: frame.midX, y: frame.midY)
        landslide.position = CGPoint(x: frame.midX, y: cameraNode.position.y - (frame.height/1.1))
    }
    
    func resetVariables() {
        gameOverLabel.isHidden = true
        overlayNode.isHidden = true
        restartButton.isHidden = true
        isSpeedReduced = false
        secondPass = false
        gameIsOver = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        targetPosition = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        targetPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if !gameIsOver {
            moveTruck()
            moveCamera()
        }
        moveLandslide()
        
        if isSpeedReduced {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                self.isSpeedReduced = false
                self.secondPass = false
            }
        }
    }
    
    func moveTruck() {
        if let targetPosition = targetPosition {
            let dx = targetPosition.x - truck.position.x
            let dy = targetPosition.y - truck.position.y
            if dy > -18 {
                let distance = sqrt(dx * dx + dy * dy)
                
                let movementThreshold: CGFloat = 100.0
                if distance < movementThreshold {
                    truck.removeAllActions()
                    return
                }
                
                let maxSpeed: CGFloat = isSpeedReduced ? 7.0 : 12.0
                let minSpeed: CGFloat = 6.0
                let distanceThreshold: CGFloat = 1000.0
                
                let speed = minSpeed + (maxSpeed - minSpeed) * (1 - min(distance / distanceThreshold, 1))
                
                if distance > 0 {
                    let angle = atan2(dy, dx)
                    let deltaX = cos(angle) * speed
                    let deltaY = sin(angle) * speed
                    truck.position.x += deltaX
                    truck.position.y += deltaY
                    
                    truck.zRotation = angle - CGFloat.pi / 2
                }
            } else {
                truck.zRotation = CGFloat.pi
                truck.position.y += 10
            }
        } else {
            truck.zRotation = CGFloat.pi
            truck.position.y += 10
        }
    }
    
    func moveCamera() {
        if let truckPosition = truck?.position {
            cameraNode.position.y = truckPosition.y + cameraDistance
            overlayNode.position.y = cameraNode.position.y
            gameOverLabel.position.y = cameraNode.position.y
            restartButton.position.y = cameraNode.position.y - 100
        }
    }
    
    func moveLandslide() {
        if gameIsOver {
            if landslide.position.y < cameraNode.position.y {
                landslide.position.y += 12
            }
        } else {
            let originalPosition = cameraNode.position.y - (frame.height/0.9)
            var bottomOfScreen = cameraNode.position.y - (frame.height/1.1)
            
            if secondPass {
                bottomOfScreen = cameraNode.position.y
            }
            
            if isSpeedReduced {
                if landslide.position.y < bottomOfScreen {
                    landslide.position.y += 12
                }
                landslide.position.y = min(landslide.position.y, bottomOfScreen)
            } else {
                if landslide.position.y > originalPosition {
                    landslide.position.y -= 6
                }
                landslide.position.y = max(landslide.position.y, originalPosition)
            }
        }
    }
    
    func changeToGameOverScene() {
        overlayNode.isHidden = false
        gameOverLabel.isHidden = false
        restartButton.isHidden = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsCategory.player || contact.bodyB.categoryBitMask == PhysicsCategory.player {
            if let truckNode = contact.bodyA.node as? TruckNode {
                truckNode.beganContact(with: contact.bodyB.node!)
            } else if let truckNode = contact.bodyB.node as? TruckNode {
                truckNode.beganContact(with: contact.bodyA.node!)
            }
        }
    }
    
    func gameOver() {
        if gameIsOver == false {
            gameIsOver = true
            changeToGameOverScene()
        }
    }
    
    func reduceSpeed() {
        if isSpeedReduced {
            secondPass = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isSpeedReduced = true
        }
    }
    
}

protocol PlayerContactDelegate: AnyObject {
    func gameOver()
    func reduceSpeed()
}
