//
//  LandslideNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import SpriteKit

class LandslideNode: SKShapeNode {
    
    weak var delegate: ObstacleContactDelegate?
    
    var landslideDistance: CGFloat = 0
    
    var originalPosition: CGFloat = 0
    var closePosition: CGFloat = 0
    var gameOverPosition: CGFloat = 0
    
    init(size: CGSize, frame: CGRect) {
        super.init()
        
        self.landslideDistance = (frame.height/0.9)
        
        self.originalPosition = frame.minY - landslideDistance
        self.closePosition = frame.minY - (frame.height/2.3)
        self.gameOverPosition = frame.midY
        
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.fillColor = .white
        
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
    
    func moveCloser() {
        self.position.y = closePosition
    }
    
    func moveUp() {
        self.position.y = gameOverPosition
    }
    
    func moveDown() {
        self.position.y = originalPosition
    }
    
}

extension LandslideNode {
    
    func beganContact(with node: SKNode) {
        if node is HoleNode || node is BlockNode {
            delegate?.deleteObstacle(obstacle: node as! SKShapeNode)
        }
    }
    
}
