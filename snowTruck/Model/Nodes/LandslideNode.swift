//
//  LandslideNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit

class LandslideNode: SKShapeNode {
    
    weak var delegate: ObstacleContactDelegate?
    
    init(size: CGSize) {
        super.init()
        
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.fillColor = .white
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.landslide
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = "landslide"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    func moveLandslide() {
//        if gameIsOver {
//            if landslide.position.y < cameraNode.position.y {
//                landslide.position.y += 12
//            }
//        } else {
//            let originalPosition = cameraNode.position.y - (frame.height/0.9)
//            var bottomOfScreen = cameraNode.position.y - (frame.height/1.1)
//
//            if secondPass {
//                bottomOfScreen = cameraNode.position.y
//            }
//
//            if truck.isSpeedReduced {
//                if landslide.position.y < bottomOfScreen {
//                    landslide.position.y += 12
//                }
//                landslide.position.y = min(landslide.position.y, bottomOfScreen)
//            } else {
//                if landslide.position.y > originalPosition {
//                    landslide.position.y -= 6
//                }
//                landslide.position.y = max(landslide.position.y, originalPosition)
//            }
//        }
//    }
    
    func moveCloser() {
        
    }
    
    func moveUp() {
        
    }
    
}

extension LandslideNode {
    
    func beganContact(with node: SKNode) {
        if node is HoleNode || node is BlockNode {
            delegate?.deleteObstacle(obstacle: node as! SKShapeNode)
        }
    }
    
}
