//
//  GameScene+ExtPlayerContactDelegate.swift
//  snowTruck
//
//  Created by Henrique Semmer on 08/04/24.
//

import Foundation

extension GameScene: PlayerContactDelegate {
    
    func gameOver() {
        if gameIsOver == false {
            truck.stop()
            // Parar de mover a tela pra baixo
            for obstacle in controller.currentObjects {
                obstacle.removeAllActions()
            }
            
            gameIsOver = true
            showGameOver()
            truck.gas = truck.maxGas
            
            objectFactory.stop()
            
            controller.totalCoins += controller.currentCoins
            print("total de moedas: \(controller.totalCoins)")
            
            if controller.currentDistance > controller.highestDistance {
                controller.highestDistance = controller.currentDistance
                GameService.shared.submitScore(Int(controller.highestDistance), ids: ["highscore"]) {}
            }
        }
    }
    
    func reduceSpeed() {
        truck.holes += 1
        print(truck.holes)
        
        self.sceneShake(shakeCount: 3, intensity: CGVector(dx: 4, dy: 1), shakeDuration: 0.2)
        HapticsService.shared.play(.heavy)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.truck.isSpeedReduced = true
            
            if self.truck.holes == 1 {
                // Mover avalanche pra colar com o caminhão
                self.landslide.move(direction: .close)
            } else if self.truck.holes == 2 {
                // Mover avalanche pra cima
                self.landslide.removeAllActions()
                
                self.landslide.move(direction: .up)
            }
        }
    }
    
    func moveLandslideUp() {
        // Mover avalanche pra cima
        landslide.removeAllActions()
        landslide.move(direction: .up)
    }
    
    func reduceGas() {
        controller.currentGas = truck.gas
        
        NotificationCenter.default.post(name: Notification.Name("GasBarUpdated"), object: nil)
    }
    
    func addGas(object: ObjectNode) {
        truck.addGas()
        
        controller.currentGas = truck.gas
        
        NotificationCenter.default.post(name: Notification.Name("GasBarUpdated"), object: nil)
        
        print(truck.gas)
        
        deleteItem(item: object)
    }
    
    func addCoin(object: ObjectNode) {
        controller.currentCoins += 1
        print(controller.currentCoins)
        
        deleteItem(item: object)
        
//        coinsNode.label.text = "\(controller.currentCoins)"
        
        NotificationCenter.default.post(name: Notification.Name("CoinLabelUpdated"), object: nil)
    }
    
    func deleteItem(item: ObjectNode) {
        controller.currentObjects.removeAll { $0.id == item.id }
        item.removeFromParent()
    }
    
}
