//
//  BlockNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 25/03/24.
//

import SpriteKit

class BlockNode: ObstacleNode {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.block
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.landslide | PhysicsCategory.block | PhysicsCategory.hole
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = "block"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
