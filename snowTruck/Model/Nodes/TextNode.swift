//
//  TextNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 30/03/24.
//

import SpriteKit

class TextNode: SKSpriteNode {
    
    var label: SKLabelNode!
    
    init(texture: SKTexture, size: CGSize, text: String, color: UIColor, secondaryTexture: SKTexture = SKTexture(), hasLabel: Bool = false) {
        super.init(texture: .none, color: .clear, size: size)
        
        let background = SKSpriteNode(texture: texture, color: .black, size: size)
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY + self.frame.height * 0.2)
        background.zPosition = 2.2
        
        self.addChild(background)
        
        if hasLabel {
            let iconLabel = SKSpriteNode(texture: secondaryTexture, color: .black, size: CGSize(width: 40, height: 40))
            iconLabel.anchorPoint = CGPoint(x: 0.5, y: 0.2)
            iconLabel.position = CGPoint(x: self.frame.midX - 25, y: self.frame.midY)
            iconLabel.zPosition = 2.3
            self.addChild(iconLabel)
        }
        
        label = SKLabelNode(text: text)
        label.fontName = "Arial"
        label.fontSize = 40
        label.fontColor = color
        if hasLabel {
            label.position = CGPoint(x: self.frame.midX + 25, y: self.frame.midY)
        } else {
            label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        }
        label.zPosition = 2.4
        
        self.addChild(label)
        self.alpha = 2.0
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 50))
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
