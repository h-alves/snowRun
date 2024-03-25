//
//  TruckNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit

class TruckNode: SKShapeNode {
    
    weak var delegate: PlayerContactDelegate?
    
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
