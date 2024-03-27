//
//  HoleNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 22/03/24.
//

import SpriteKit

class HoleNode: ObstacleNode {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.hole
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.landslide | PhysicsCategory.hole | PhysicsCategory.block
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = "hole"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
