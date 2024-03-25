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
    
}

extension LandslideNode {
    
    func beganContact(with node: SKNode) {
        if node is HoleNode || node is BlockNode {
            delegate?.deleteObstacle(obstacle: node as! SKShapeNode)
        }
    }
    
}
