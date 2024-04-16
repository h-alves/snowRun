//
//  MenuScene.swift
//  snowTruck
//
//  Created by Henrique Semmer on 12/04/24.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        setUpBackground()
        setUpTruck()
    }
    
    func setUpBackground() {
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "background"), size: frame.size)
        background.zPosition = 0
        addChild(background)
    }
    
    func setUpTruck() {
        let truck = TruckNode(texture: SKTexture(imageNamed: "truck"), color: .black, size: CGSize(width: 100, height: 160))
        truck.distance = (frame.height/3.4)
        truck.position = CGPoint(x: frame.midX, y: frame.midY - truck.distance)
        truck.zPosition = 2.1
        
        addChild(truck)
    }
    
}
