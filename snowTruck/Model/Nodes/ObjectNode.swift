//
//  ObjectNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 29/03/24.
//

import SpriteKit

class ObjectNode: SKShapeNode, Object {
    
    var id: UUID = UUID()
    var typeName: String
    var size: CGSize
    var color: UIColor
    
    weak var delegate: ObjectContactDelegate?
    
    init(typeName: String, size: CGSize, color: UIColor) {
        self.typeName = typeName
        self.size = size
        self.color = color
        
        super.init()
        
        self.draw()
        self.configureCollision()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.typeName = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.size = aDecoder.decodeCGSize(forKey: "size")
        self.color = aDecoder.decodeObject(forKey: "color") as? UIColor ?? .white
        
        super.init(coder: aDecoder)
    }
    
    func draw() {
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.fillColor = color
    }
    
    func configureCollision() {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
        self.name = self.typeName
    }
    
    func spawn(_ scene: SKScene, offset: CGFloat) {
        let xPosition = CGFloat.random(in: (scene.frame.minX + self.frame.width)...(scene.frame.maxX - self.frame.width))
        let yPosition = scene.frame.maxY + offset
        
        self.position = CGPoint(x: xPosition, y: yPosition)
        
        scene.addChild(self)
        
        GameController.shared.currentObjects.append(self)
        
        let speed = max((GameController.shared.currentDistance / 1000), 1.0) * 6.0
        
        self.moveDown(scene.frame.minY - 100, speed: speed)
    }

    func beganContact(with object: ObjectNode) {
        delegate?.deleteObject(object: object)
    }
    
    func moveDown(_ finalSpace: CGFloat, speed: TimeInterval) {
        let move = SKAction.moveTo(y: finalSpace, duration: speed)
        self.run(move)
    }
    
    func clone() -> any Object {
        ObjectNode(typeName: typeName, size: size, color: color)
    }
    
}
