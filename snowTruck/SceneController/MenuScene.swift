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
        let overlayNode = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        overlayNode.position = CGPoint(x: frame.midX, y: frame.midY)
        overlayNode.fillColor = .white
        self.addChild(overlayNode)
        
        let titleLabel = SKLabelNode(text: "Snow Truck")
        titleLabel.fontName = "Arial"
        titleLabel.fontSize = 70
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 200)
        self.addChild(titleLabel)
        
        restartButton = ButtonNode(size: CGSize(width: 200, height: 50), text: "Start", color: .red)
        restartButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        self.addChild(restartButton)
        
        let highscoreLabel = SKLabelNode(text: "Highscore: \(Int(GameController.shared.highestDistance)) m")
        highscoreLabel.fontName = "Arial"
        highscoreLabel.fontSize = 40
        highscoreLabel.fontColor = .black
        highscoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        self.addChild(highscoreLabel)
        
        let coinsLabel = SKLabelNode(text: "Moedas: \(GameController.shared.totalCoins)")
        coinsLabel.fontName = "Arial"
        coinsLabel.fontSize = 40
        coinsLabel.fontColor = .black
        coinsLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(coinsLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if restartButton.contains(touchLocation) {
            startGame()
            GameService.shared.hideAccessPoint()
        }
    }
    
    func startGame() {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameScene, transition: transition)
    }
    
}
