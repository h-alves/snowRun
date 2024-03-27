//
//  CoinNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 27/03/24.
//

import SpriteKit

class CoinNode: ObstacleNode {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.landslide
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = "coin"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
