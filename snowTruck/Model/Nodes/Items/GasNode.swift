//
//  GasNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 27/03/24.
//

import SpriteKit

class GasNode: ObstacleNode {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.gas
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.landslide
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = "gas"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
