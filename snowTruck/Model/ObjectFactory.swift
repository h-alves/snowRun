//
//  ObjectFactory.swift
//  snowTruck
//
//  Created by Henrique Semmer on 29/03/24.
//

import SpriteKit

class ObjectFactory: SKNode {
    
    var offset: CGFloat = 0
    
    init(offset: CGFloat) {
        super.init()
        
        self.offset = offset
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createObject(_ object: ObjectNode, mainScene: SKScene) {
        let clone = object.clone()
        clone.draw()
        clone.configureCollision()
        
        clone.spawn(mainScene, offset: self.offset)
    }
    
    func start(_ mainScene: SKScene) {
        for object in ObjectTypes.allCases {
            print(object)
            var newObject: ObjectNode
            
            switch object {
            case .block:
                newObject = BlockNode(size: CGSize(width: 200, height: 100))
            case .hole:
                newObject = HoleNode(size: CGSize(width: 50, height: 50))
            case .gas:
                newObject = GasNode(size: CGSize(width: 50, height: 50))
            case .coin:
                newObject = CoinNode(size: CGSize(width: 50, height: 50))
            }
            
            let sequence: [SKAction] = [.wait(forDuration: object.rawValue), .run {
                self.createObject(newObject, mainScene: mainScene)
            }]
            
            self.run(.repeatForever(.sequence(sequence)))
        }
    }
    
    func stop() {
        removeAllActions()
    }
    
}
