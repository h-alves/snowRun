//
//  Object.swift
//  snowTruck
//
//  Created by Henrique Semmer on 29/03/24.
//

import SpriteKit

protocol Object {
    var id: UUID { get }
    var typeName: String { get }
    var size: CGSize { get }
    var color: UIColor { get }
    
    func draw()
    func configureCollision()
    func spawn(_ scene: SKScene, offset: CGFloat)
    func beganContact(with object: ObjectNode)
    func moveDown(_ finalSpace: CGFloat, speed: TimeInterval)
    func clone() -> Object
}
