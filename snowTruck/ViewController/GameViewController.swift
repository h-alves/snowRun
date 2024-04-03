//
//  GameViewController.swift
//  snowTruck
//
//  Created by Henrique Semmer on 21/03/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: UIScreen.main.bounds)
        guard let view = self.view as? SKView else {
            fatalError("View do GameViewController não é uma SKView.")
        }
        
        if let scene = GKScene(fileNamed: "GameScene") {
            if let sceneNode = scene.rootNode as? GameScene {
                sceneNode.scaleMode = .aspectFill
                
                view.presentScene(sceneNode)
                view.ignoresSiblingOrder = true
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        [.portrait, .portraitUpsideDown]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
    }
}
