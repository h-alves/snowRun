//
//  LandslideNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit

class LandslideNode: SKSpriteNode {
    
    weak var delegate: ObjectContactDelegate?
    
    var landslideDistance: CGFloat = 0
    
    var originalPosition: CGFloat = 0
    var closePosition: CGFloat = 0
    var gameOverPosition: CGFloat = 0
    
    var secondaryAction: (() -> Void)!
    
    init(texture: SKTexture, size: CGSize, frame: CGRect) {
        super.init(texture: texture, color: .red, size: size)
        
        self.landslideDistance = (frame.height/1.8)
        
        self.originalPosition = frame.minY - landslideDistance
        self.closePosition = frame.minY - (frame.height/2.3)
        self.gameOverPosition = frame.midY
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.landslide
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        self.name = "landslide"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func move(direction: LandslideDirection) {
        var move = [SKAction]()
        
        switch direction {
        case .close:
            move = [SKAction.moveTo(y: closePosition, duration: 0.7), .wait(forDuration: 6.3), .moveTo(y: originalPosition, duration: 0.7), .run {
                self.secondaryAction()
            }]
        case .down:
            move = [SKAction.moveTo(y: originalPosition, duration: 0.7)]
        case .up:
            move = [SKAction.moveTo(y: gameOverPosition, duration: 1.5)]
        }
        
        self.run(.sequence(move))
    }
    
}

extension LandslideNode {
    
    func beganContact(with node: SKNode) {
        if node is ObjectNode {
            delegate?.deleteObject(object: node as! ObjectNode)
        }
    }
    
}
