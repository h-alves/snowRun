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
        newBlock.fillColor = .blue
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
        newHole.fillColor = .green
        newHole.zPosition = 1
        
        return newHole
    }
    
    func createRandomObstacle() -> ObstacleNode {
        let newBlock = self.createBlock()
        let newHole = self.createHole()
        var list: [ObstacleNode] = [ObstacleNode]()
        
        list.append(newHole)
        list.append(newBlock)
        
        let child = list.randomElement()!
        
        return child
    }
    
}
