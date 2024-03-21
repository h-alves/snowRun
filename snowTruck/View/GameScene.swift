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
    let cameraSpeed: CGFloat = 0.1
    
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
        truck = TruckNode(size: CGSize(width: 100, height: 200), color: .red)
        truck.position = CGPoint(x: frame.midX, y: frame.midY)
        
        addChild(truck)
    }
    
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
    
    override func update(_ currentTime: TimeInterval) {
        moveTruck()
        moveCamera()
    }
    
    func moveTruck() {
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
    
    func moveCamera() {
        if let truckPosition = truck?.position {
            let desiredCameraY = truckPosition.y + 350
            let dy = desiredCameraY - cameraNode.position.y
            cameraNode.position.y += dy * cameraSpeed
        }
    }
    
}
