//
//  TruckNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit

class TruckNode: SKShapeNode {
    
    init(size: CGSize, color: UIColor) {
        super.init()
        
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.fillColor = color
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
