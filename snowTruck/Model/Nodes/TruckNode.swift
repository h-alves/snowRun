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
    
    var gas: Int = 100
    
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
            
            if dy < -20 {
                dy = 200
            } else if dy < 100 {
                dy = 100
            } else if dy > 300 {
                dy = 300
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
            }
        } else {
            self.zRotation = CGFloat.pi
        }
    }
    
}

extension TruckNode {
    
    func beganContact(with node: SKNode) {
        let name = node.name
        if node is LandslideNode || node is BlockNode {
            delegate?.gameOver()
            if node is BlockNode {
                delegate?.moveLandslideUp()
            }
        } else if node is HoleNode {
            delegate?.reduceSpeed()
        } else if node is GasNode {
            delegate?.addGas(object: node as! ItemNode)
        } else if node is CoinNode {
            delegate?.addCoin(object: node as! ItemNode)
        }
        switch name {
        case "landslide":
            delegate?.gameOver()
        case "block":
            delegate?.gameOver()
            delegate?.moveLandslideUp()
        case "hole":
            delegate?.reduceSpeed()
        case "gas":
            delegate?.addGas(object: node as! ObjectNode)
        case "coin":
            delegate?.addCoin(object: node as! ObjectNode)
        default:
            break
        }
    }
    
}
