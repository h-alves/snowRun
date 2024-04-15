//
//  MenuViewController.swift
//  snowTruck
//
//  Created by Henrique Semmer on 02/04/24.
//

import UIKit
import SpriteKit
import GameplayKit
import AppTrackingTransparency

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = SKView(frame: UIScreen.main.bounds)
        guard let view = self.view as? SKView else {
            fatalError("View do GameViewController não é uma SKView.")
        }
        
        if let scene = GKScene(fileNamed: "MenuScene") {
            if let sceneNode = scene.rootNode as? MenuScene {
                sceneNode.scaleMode = .aspectFill
                
                view.presentScene(sceneNode)
                view.ignoresSiblingOrder = true
            }
        }

        addSubviews()
        setUpConstraints()
        
        GameService.shared.authenticate { error in
            
        }
    }
    
    private func addSubviews() {
        view.addSubview(titleImage)
        view.addSubview(startButton)
        view.addSubview(gameCenterButton)
    }
    
    private func setUpConstraints() {
        titleImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: (-50)).isActive = true
        
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: (60)).isActive = true
        
        gameCenterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameCenterButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: (-70)).isActive = true
    }
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.image = UIImage(named: "menuBackground")
        
        return view
    }()
    
    private lazy var titleImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "menuLogo")
        
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "start"), for: .normal)
        view.isEnabled = true
        view.addTarget(self, action: #selector(goToGameScene), for: .touchUpInside)
        
        return view
    }()
    
    @objc
    private func goToGameScene() {
        navigationController?.pushViewController(GameViewController(), animated: false)
    }
    
    private lazy var gameCenterButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "gameCenter"), for: .normal)
        view.isEnabled = true
        view.addTarget(self, action: #selector(openGameCenter), for: .touchUpInside)
        
        return view
    }()
    
    @objc
    private func openGameCenter() {
        GameService.shared.showLeaderboard()
    }

}
