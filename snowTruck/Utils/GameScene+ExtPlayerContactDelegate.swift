//
//  GameScene+ExtPlayerContactDelegate.swift
//  snowTruck
//
//  Created by Henrique Semmer on 08/04/24.
//

import Foundation

extension GameScene: PlayerContactDelegate {
    
    func gameOver() {
        if controller.gameIsOver == false {
            // Parar de mover a tela pra baixo
            for obstacle in controller.currentObjects {
                obstacle.removeAllActions()
            }
            
            controller.gameIsOver = true
            controller.showGameOver()
            
            controller.objectFactory.stop()
            
            controller.totalCoins += controller.currentCoins
            print("total de moedas: \(controller.totalCoins)")
            
            if controller.currentDistance > controller.highestDistance {
                controller.highestDistance = controller.currentDistance
                GameService.shared.submitScore(Int(controller.highestDistance), ids: ["highscore"]) {}
            }
        }
    }
    
    func reduceSpeed() {
        controller.truck.holes += 1
        print(controller.truck.holes)
        
        self.sceneShake(shakeCount: 3, intensity: CGVector(dx: 4, dy: 1), shakeDuration: 0.2)
        HapticsService.shared.play(.heavy)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.controller.truck.isSpeedReduced = true
            
            if self.controller.truck.holes == 1 {
                // Mover avalanche pra colar com o caminhão
                self.controller.landslide.move(direction: .close)
            } else if self.controller.truck.holes == 2 {
                // Mover avalanche pra cima
                self.controller.landslide.removeAllActions()
                
                self.controller.landslide.move(direction: .up)
            }
        }
    }
    
    func moveLandslideUp() {
        // Mover avalanche pra cima
        controller.landslide.removeAllActions()
        controller.landslide.move(direction: .up)
    }
    
    func addGas(object: ObjectNode) {
        controller.truck.gas += 20
        if controller.truck.gas > 100 {
            controller.truck.gas = 100
        }
        
        print(controller.truck.gas)
        
        deleteItem(item: object)
    }
    
    func addCoin(object: ObjectNode) {
        controller.currentCoins += 1
        print(controller.currentCoins)
        
        deleteItem(item: object)
        
        controller.coinsNode.label.text = "\(controller.currentCoins)"
    }
    
    func deleteItem(item: ObjectNode) {
        controller.currentObjects.removeAll { $0.id == item.id }
        item.removeFromParent()
    }
    
}
