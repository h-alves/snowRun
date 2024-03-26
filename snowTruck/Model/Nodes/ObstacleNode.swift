//
//  ObstacleNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 26/03/24.
//

import SpriteKit

class ObstacleNode: SKShapeNode {
    
    init(size: CGSize) {
        super.init()
        
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.fillColor = .white
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func moveDown(finalSpace: CGFloat) {
        let move = SKAction.moveTo(y: finalSpace, duration: 6.0)
        self.run(move)
    }
    
}
