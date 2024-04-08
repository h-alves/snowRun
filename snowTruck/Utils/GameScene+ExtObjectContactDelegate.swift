//
//  GameScene+ExtObjectContactDelegate.swift
//  snowTruck
//
//  Created by Henrique Semmer on 08/04/24.
//

import Foundation

extension GameScene: ObjectContactDelegate {
    
    func deleteObject(object: ObjectNode) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Remover obstáculo da tela
            object.removeFromParent()
            self.controller.currentObjects.removeAll { $0.id == object.id }
        }
    }
    
    func deleteOnPosition(objectA: ObjectNode, objectB: ObjectNode) {
        print("ObjectA: \(objectA) ObjectB: \(objectB)")
        objectB.removeFromParent()
        self.controller.currentObjects.removeAll { $0.id == objectB.id }
    }
    
}
