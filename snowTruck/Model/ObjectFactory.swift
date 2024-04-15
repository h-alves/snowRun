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
        clone.configureCollision()
        
        clone.spawn(mainScene, offset: self.offset)
    }
    
    func start(_ mainScene: SKScene) {
        for object in ObjectTypes.allCases {
            print(object)
            var newObject: ObjectNode
            var texture: SKTexture
            
            switch object {
            case .block:
                texture = SKTexture(imageNamed: "block1")
                newObject = BlockNode(texture: texture, size: CGSize(width: 140, height: 140))
            case .hole:
                texture = SKTexture(imageNamed: "hole")
                newObject = HoleNode(texture: texture, size: CGSize(width: 120, height: 120))
            case .gas:
                texture = SKTexture(imageNamed: "gas")
                newObject = GasNode(texture: texture, size: CGSize(width: 90, height: 90))
            case .coin:
                texture = SKTexture(imageNamed: "coin")
                newObject = CoinNode(texture: texture, size: CGSize(width: 70, height: 70))
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
