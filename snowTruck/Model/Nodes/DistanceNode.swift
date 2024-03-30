//
//  DistanceNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 30/03/24.
//

import SpriteKit

class DistanceNode: SKSpriteNode {
    
    var distanceLabel: SKLabelNode!
    
    init(size: CGSize, text: String, color: UIColor) {
        super.init(texture: .none, color: .clear, size: size)
        
        distanceLabel = SKLabelNode(text: text)
        distanceLabel.fontName = "Arial"
        distanceLabel.fontSize = 40
        distanceLabel.fontColor = color
        
        self.addChild(distanceLabel)
        self.alpha = 2.0
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 50))
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
