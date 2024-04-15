//
//  TruckNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit

class TruckNode: SKSpriteNode {
    
    weak var delegate: PlayerContactDelegate?
    
    var isSpeedReduced: Bool = false
    var distance: CGFloat = 0
    
    var gas: Int = 100
    let maxGas: Int = 100
    var holes: Int = 0
    
    init(texture: SKTexture, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
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
    
    func consumeGas() {
        let sequence: [SKAction] = [.wait(forDuration: 2.0), .run {
            self.gas -= 10
            if self.gas < 0 {
                self.gas = 0
                self.delegate?.gameOver()
            }
            
            self.delegate?.reduceGas()
        }]
        
        self.run(.repeatForever(.sequence(sequence)))
    }
    
    func addGas() {
        stop()
        
        self.gas += 20
        
        if self.gas > self.maxGas {
            self.gas = self.maxGas
        }
        
        consumeGas()
    }
    
    func stop() {
        self.removeAllActions()
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
            self.zRotation = 0
        }
    }
    
}

extension TruckNode {
    
    func beganContact(with node: SKNode) {
        let name = node.name
        
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
