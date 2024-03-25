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
    
    func createBlock() -> LandslideNode {
        let width = CGFloat.random(in: 40...160)
        let height = width
        
        let xPosition = CGFloat.random(in: frame.minX...frame.maxX)
        let yPosition = cameraY + CGFloat.random(in: frame.height...(frame.height * 1.1)) + height / 2
        
        let newBlock = LandslideNode(size: CGSize(width: width, height: height))
        newBlock.position = CGPoint(x: xPosition, y: yPosition)
        
        return newBlock
    }
    
}
