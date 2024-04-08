//
//  HoleNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 22/03/24.
//

import SpriteKit

class HoleNode: ObstacleNode {
    
    override init(typeName: String = "hole", texture: SKTexture, color: UIColor = .systemPink, size: CGSize = CGSize(width: 50, height: 50)) {
        super.init(typeName: typeName, texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func configureCollision() {
        super.configureCollision()
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.hole
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.landslide | PhysicsCategory.block | PhysicsCategory.hole | PhysicsCategory.gas | PhysicsCategory.coin
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = self.name
    }
    
}
