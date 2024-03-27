//
//  ObstacleFactory.swift
//  snowTruck
//
//  Created by Henrique Semmer on 25/03/24.
//

import SpriteKit

class ObstacleFactory {
    
    var frame: CGRect
    var offset: CGFloat
    
    init(frame: CGRect, offset: CGFloat) {
        self.frame = frame
        self.offset = offset
    }
    
    func createBlock() -> BlockNode {
        let width = 200.0
        let height = 100.0
        
        let xPosition = CGFloat.random(in: (frame.minX + width)...(frame.maxX - width))
        let yPosition = frame.maxY + offset
        
        let newBlock = BlockNode(size: CGSize(width: width, height: height))
        newBlock.position = CGPoint(x: xPosition, y: yPosition)
        newBlock.fillColor = .red
        newBlock.zPosition = 1
        
        return newBlock
    }
    
    func createHole() -> HoleNode {
        let width = 50.0
        let height = 50.0
        
        let xPosition = CGFloat.random(in: (frame.minX + width)...(frame.maxX - width))
        let yPosition = frame.maxY + offset
        
        let newHole = HoleNode(size: CGSize(width: width, height: height))
        newHole.position = CGPoint(x: xPosition, y: yPosition)
        newHole.fillColor = .blue
        newHole.zPosition = 1
        
        return newHole
    }
    
    func createRandomObstacle() -> ObstacleNode {
        let child: ObstacleNode!
        
        let randomObstacle = ObstacleTypes.allCases.randomElement()
        
        switch randomObstacle {
        case .block:
            child = self.createBlock()
        case .hole:
            child = self.createHole()
        case nil:
            child = nil
        }
        
        return child
    }
    
}
