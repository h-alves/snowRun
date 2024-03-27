//
//  ItemFactory.swift
//  snowTruck
//
//  Created by Henrique Semmer on 27/03/24.
//

import SpriteKit

class ItemFactory {
    
    var frame: CGRect
    var offset: CGFloat
    
    init(frame: CGRect, offset: CGFloat) {
        self.frame = frame
        self.offset = offset
    }
    
    func createGas() -> GasNode {
        let width = 50.0
        let height = 50.0
        
        let xPosition = CGFloat.random(in: (frame.minX + width)...(frame.maxX - width))
        let yPosition = frame.maxY + offset
        
        let newGas = GasNode(size: CGSize(width: width, height: height))
        newGas.position = CGPoint(x: xPosition, y: yPosition)
        newGas.fillColor = .green
        newGas.zPosition = 1
        
        return newGas
    }
    
    func createCoin() -> CoinNode {
        let width = 50.0
        let height = 50.0
        
        let xPosition = CGFloat.random(in: (frame.minX + width)...(frame.maxX - width))
        let yPosition = frame.maxY + offset
        
        let newCoin = CoinNode(size: CGSize(width: width, height: height))
        newCoin.position = CGPoint(x: xPosition, y: yPosition)
        newCoin.fillColor = .yellow
        newCoin.zPosition = 1
        
        return newCoin
    }
    
    func createRandomObstacle() -> ObstacleNode {
        let child: ObstacleNode!
        
        let randomItem = ItemTypes.allCases.randomElement()
        
        switch randomItem {
        case .gas:
            child = self.createGas()
        case .coin:
            child = self.createCoin()
        case nil:
            child = nil
        }
        
        return child
    }
    
}
