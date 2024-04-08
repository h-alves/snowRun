//
//  ButtonNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 22/03/24.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    
    init(size: CGSize, text: String, color: UIColor) {
        super.init(texture: SKTexture(imageNamed: text), color: .clear, size: size)
        
//        let restartLabel = SKLabelNode(text: text)
//        restartLabel.fontName = "Arial"
//        restartLabel.fontSize = 40
//        restartLabel.fontColor = color
//        
//        self.addChild(restartLabel)
        self.alpha = 2.0
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
