//
//  RestartButtonNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 22/03/24.
//

import SpriteKit

class RestartButtonNode: SKSpriteNode {
    
    init(size: CGSize, text: String, color: UIColor) {
        super.init(texture: .none, color: .clear, size: size)
        
        let restartLabel = SKLabelNode(text: text)
        restartLabel.fontName = "Arial"
        restartLabel.fontSize = 40
        restartLabel.fontColor = color
        
        self.addChild(restartLabel)
        self.alpha = 2.0
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 50))
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
