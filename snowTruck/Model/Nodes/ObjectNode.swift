//
//  ObjectNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 29/03/24.
//

import SpriteKit

class ObjectNode: SKSpriteNode, Object {
    
    var id: UUID = UUID()
    var typeName: String
    
    weak var delegate: ObjectContactDelegate?
    
    
    init(typeName: String, texture: SKTexture, color: UIColor, size: CGSize) {
        self.typeName = typeName
        
        super.init(texture: texture, color: color, size: size)
        
        self.configureCollision()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.typeName = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        
        super.init(coder: aDecoder)
    }
    
    func configureCollision() {
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width - 10, height: self.size.height - 10))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.landslide | PhysicsCategory.block | PhysicsCategory.hole | PhysicsCategory.gas | PhysicsCategory.coin
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        self.name = self.typeName
    }
    
    func spawn(_ scene: SKScene, offset: CGFloat) {
        let xPosition = CGFloat.random(in: (scene.frame.minX + self.frame.width)...(scene.frame.maxX - self.frame.width))
        let yPosition = scene.frame.maxY + offset
        
        self.position = CGPoint(x: xPosition, y: yPosition)
        self.zPosition = 2
        
        scene.addChild(self)
        self.delegate = scene as? any ObjectContactDelegate
        
        GameManager.shared.currentObjects.append(self)
        
        let speed = max((GameManager.shared.currentDistance / 1000), 1.0) * 6.0
        
        self.moveDown(scene.frame.minY - 100, speed: speed)
    }

    func beganContact(with object: ObjectNode) {
        print("teve contato")
        delegate?.deleteOnPosition(objectA: self, objectB: object)
    }
    
    func moveDown(_ finalSpace: CGFloat, speed: TimeInterval) {
        let move = SKAction.moveTo(y: finalSpace, duration: speed)
        self.run(move)
    }
    
    func clone() -> any Object {
        ObjectNode(typeName: typeName, texture: self.texture!, color: self.color, size: self.size)
    }
    
}
