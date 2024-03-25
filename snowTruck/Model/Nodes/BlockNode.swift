//
//  BlockNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 25/03/24.
//

import SpriteKit

class BlockNode: SKShapeNode {
    
    init(size: CGSize) {
        super.init()
        
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.fillColor = .white
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.block
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.landslide | PhysicsCategory.block | PhysicsCategory.hole
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = "block"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
