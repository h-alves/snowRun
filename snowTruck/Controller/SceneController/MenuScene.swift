//
//  MenuScene.swift
//  snowTruck
//
//  Created by Henrique Semmer on 12/04/24.
//

import SpriteKit

class MenuScene: SKScene {
    
    var snow: SKSpriteNode!
    var run: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setUpBackground()
        setUpTruck()
        
        setUpTitle()
        
        moveTitle()
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
    
    func setUpTitle() {
        snow = SKSpriteNode(texture: SKTexture(imageNamed: "snow"), size: CGSize(width: frame.width * 0.5, height: frame.height * 0.11))
        run = SKSpriteNode(texture: SKTexture(imageNamed: "run"), size: CGSize(width: frame.width * 0.35, height: frame.height * 0.1))
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        }
        
        snow.position = CGPoint(x: frame.minX - snow.frame.width / 2, y: frame.midY + snow.frame.height * 2)
        snow.zPosition = 3
        
        run.position = CGPoint(x: frame.maxX + run.frame.width / 2, y: snow.position.y - snow.frame.height * 0.8)
        run.zPosition = 3
        
        addChild(snow)
        addChild(run)
    }
    
    func moveTitle() {
        snow.run(.moveTo(x: frame.midX, duration: 0.7))
        run.run(.sequence([.wait(forDuration: 0.5), .moveTo(x: frame.midX, duration: 0.8)]))
    }
    
}
