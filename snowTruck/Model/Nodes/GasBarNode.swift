//
//  GasBarNode.swift
//  snowTruck
//
//  Created by Henrique Semmer on 04/04/24.
//

import SpriteKit

class GasBarNode: SKShapeNode {
    
    var size: CGSize!
    var gasSpeed: CGFloat = 2.0
    var totalGas: Int = 100
    
    var decreaseFunc: (() -> Void)!
    
    init(size: CGSize) {
        super.init()
        
        self.size = size
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.fillColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func decreaseGas(size: CGSize, difference: CGFloat) {
        self.size = size
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.position = CGPoint(x: self.position.x, y: self.position.y - difference / 2)
    }
    
    func increaseGas(size: CGSize, difference: CGFloat) {
        self.size = size
        self.path = CGPath(rect: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: size), transform: nil)
        self.position = CGPoint(x: self.position.x, y: self.position.y + difference / 2)
    }
    
    func start(frame: CGRect) {
        let sequence: [SKAction] = [.wait(forDuration: self.gasSpeed), .run {
            self.decreaseFunc()
            
            let maxGasHeight = frame.height - 300
            let remainingGasHeight = maxGasHeight * CGFloat(self.totalGas) / 100
            
            let difference = self.size.height - remainingGasHeight
            
            self.decreaseGas(size: CGSize(width: self.frame.width, height: remainingGasHeight), difference: difference)
        }]
        
        self.run(.repeatForever(.sequence(sequence)))
    }
    
    func addGas(truckGas: Int, frame: CGRect) {
        self.stop()
        self.totalGas = truckGas
        
        let maxGasHeight = frame.height - 300
        let remainingGasHeight = maxGasHeight * CGFloat(self.totalGas) / 100
        
        let difference = remainingGasHeight - self.frame.height
        
        self.increaseGas(size: CGSize(width: 30, height: remainingGasHeight), difference: difference)
        
        self.start(frame: frame)
    }
    
    func stop() {
        removeAllActions()
    }
    
}
