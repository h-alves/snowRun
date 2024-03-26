//
//  MenuScene.swift
//  snowTruck
//
//  Created by Henrique Semmer on 26/03/24.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    var restartButton: ButtonNode!
    
    override func didMove(to view: SKView) {
        let gameOverLabel = SKLabelNode(text: "Opa")
        gameOverLabel.fontName = "Arial"
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(gameOverLabel)
        
        restartButton = ButtonNode(size: CGSize(width: 200, height: 50), text: "start", color: .yellow)
        restartButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        self.addChild(restartButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if restartButton.contains(touchLocation) {
            startGame()
        }
    }
    
    func startGame() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameScene, transition: transition)
    }
    
}
