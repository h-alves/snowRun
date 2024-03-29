//
//  CoinNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 27/03/24.
//

import SpriteKit

class CoinNode: ItemNode {
    
    override init(typeName: String = "coin", size: CGSize = CGSize(width: 50, height: 50), color: UIColor = .yellow) {
        super.init(typeName: typeName, size: size, color: color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func configureCollision() {
        super.configureCollision()
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.landslide | PhysicsCategory.block | PhysicsCategory.hole | PhysicsCategory.gas | PhysicsCategory.coin
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = self.name
    }
    
}
