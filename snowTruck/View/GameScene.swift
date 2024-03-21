//
//  GameScene.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var truck: TruckNode!
    var targetPosition: CGPoint?
    var cameraNode: SKCameraNode!
    
    override func didMove(to view: SKView) {
        setUpBackground()
        setUpCamera()
        setUpTruck()
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
    
    func setUpTruck() {
        truck = TruckNode(size: CGSize(width: 50, height: 100), color: .red)
        truck.position = CGPoint(x: frame.midX, y: frame.midY)
        
        addChild(truck)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        targetPosition = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        targetPosition = touch.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        targetPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let targetPosition = targetPosition {
            let dx = targetPosition.x - truck.position.x
            let dy = targetPosition.y - truck.position.y
            let distance = sqrt(dx * dx + dy * dy)
            
            let movementThreshold: CGFloat = 100.0
            if distance < movementThreshold {
                truck.removeAllActions()
                return
            }
            
            let maxSpeed: CGFloat = 20.0
            let minSpeed: CGFloat = 5.0
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
        }
    }
    
}
