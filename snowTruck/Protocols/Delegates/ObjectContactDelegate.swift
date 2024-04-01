//
//  ObjectContactDelegate.swift
//  snowTruck
//
//  Created by Henrique Semmer on 26/03/24.
//

import SpriteKit

protocol ObjectContactDelegate: AnyObject {
    func deleteObject(object: ObjectNode)
    func deleteOnPosition(objectA: ObjectNode, objectB: ObjectNode)
}
