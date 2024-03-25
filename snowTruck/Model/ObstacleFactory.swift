//
//  ObstacleFactory.swift
//  snowTruck
//
//  Created by Henrique Semmer on 25/03/24.
//

import SpriteKit

class ObstacleFactory {
    
    var frame: CGRect
    var cameraY: CGFloat
    
    init(frame: CGRect, cameraY: CGFloat) {
        self.frame = frame
        self.cameraY = cameraY
    }
    
    func createBlock() -> BlockNode {
        let width = CGFloat.random(in: 100...300)
        let height = 100.0
        
        let xPosition = CGFloat.random(in: (frame.minX + width)...(frame.maxX - width))
        let yPosition = cameraY + CGFloat.random(in: frame.height...(frame.height * 1.1)) + height / 2
        
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
        let yPosition = cameraY + CGFloat.random(in: frame.minY...frame.maxY)
        
        let newHole = HoleNode(size: CGSize(width: width, height: height))
        newHole.position = CGPoint(x: xPosition, y: yPosition)
        newHole.fillColor = .green
        newHole.zPosition = 1
        
        return newHole
    }
    
}
