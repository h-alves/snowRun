//
//  BlockNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 25/03/24.
//

import SpriteKit

class BlockNode: ObstacleNode {
    
    override init(typeName: String = "block", texture: SKTexture, color: UIColor = .red, size: CGSize = CGSize(width: 200, height: 100)) {
        super.init(typeName: typeName, texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func configureCollision() {
        super.configureCollision()
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.block
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.landslide | PhysicsCategory.block | PhysicsCategory.hole | PhysicsCategory.gas | PhysicsCategory.coin
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = self.name
    }
    
    override func clone() -> any Object {
        let randomBlock = Int.random(in: 1...3)
        let texture = SKTexture(imageNamed: "block\(randomBlock)")
        
        var size = CGSize()
        
        switch randomBlock {
        case 1:
            size = CGSize(width: 260, height: 140)
        case 2:
            size = CGSize(width: 210, height: 190)
        case 3:
            size = CGSize(width: 240, height: 150)
        default:
            break
        }
        
        return BlockNode(typeName: typeName, texture: texture, color: self.color, size: size)
    }
    
}
