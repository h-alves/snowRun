//
//  TruckNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit

class TruckNode: SKShapeNode {
    
    weak var delegate: PlayerContactDelegate?
    
    var isSpeedReduced: Bool = false
    
    init(size: CGSize, color: UIColor) {
        super.init()
        
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.fillColor = color
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.landslide | PhysicsCategory.hole | PhysicsCategory.block
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = "truck"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func move(targetPosition: CGPoint?) {
        if let targetPosition = targetPosition {
            let dx = targetPosition.x - self.position.x
            var dy = targetPosition.y - self.position.y
            
            if dy < 100 {
                dy = 100
            }
            
            let distance = sqrt(dx * dx + dy * dy)
            
            let movementThreshold: CGFloat = 100.0
            if distance < movementThreshold {
                self.removeAllActions()
                return
            }
            
            let maxSpeed: CGFloat = self.isSpeedReduced ? 7.0 : 12.0
            let minSpeed: CGFloat = 6.0
            let distanceThreshold: CGFloat = 1000.0
            
            let speed = minSpeed + (maxSpeed - minSpeed) * (1 - min(distance / distanceThreshold, 1))
            
            if distance > 0 {
                let angle = atan2(dy, dx)
                let deltaX = cos(angle) * speed
                
                self.position.x += deltaX
                
                self.zRotation = angle - CGFloat.pi / 2
                self.position.y += 10
            }
        } else {
            self.zRotation = CGFloat.pi
            self.position.y += 10
        }
    }
    
}

extension TruckNode {
    
    func beganContact(with node: SKNode) {
        if node is LandslideNode || node is BlockNode {
            delegate?.gameOver()
        } else if node is HoleNode {
            delegate?.reduceSpeed()
        }
    }
    
}
