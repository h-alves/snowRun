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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // Check if the tap location intersects with the game center button frame
        if gameCenterButton.frame.contains(tapLocation) {
            openGameCenter()
        } else {
            // If not, navigate to GameViewController
            goToGameScene()
        }
    }
    
    private func addSubviews() {
        view.addSubview(titleImage)
        view.addSubview(startButton)
        view.addSubview(gameCenterButton)
    }
    
    private func setUpConstraints() {
        titleImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * 0.05).isActive = true
        titleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.05).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            titleImage.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
            titleImage.bottomAnchor.constraint(equalTo: titleImage.topAnchor, constant: UIScreen.main.bounds.height * 0.35).isActive = true
        } else {
            titleImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.05).isActive = true
            titleImage.bottomAnchor.constraint(equalTo: titleImage.topAnchor, constant: UIScreen.main.bounds.height * 0.3).isActive = true
        }
        
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        
        gameCenterButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -UIScreen.main.bounds.width * 0.08).isActive = true
        gameCenterButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: UIScreen.main.bounds.width * 0.08).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            gameCenterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.01).isActive = true
            gameCenterButton.topAnchor.constraint(equalTo: gameCenterButton.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.09).isActive = true
        } else {
            gameCenterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            gameCenterButton.topAnchor.constraint(equalTo: gameCenterButton.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.08).isActive = true
        }
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
        view.setTitle("PRESS TO START", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = UIFont(name: "Gameshow", size: 32)
        view.isEnabled = true
        view.addTarget(self, action: #selector(goToGameScene), for: .touchUpInside)
        
        return view
    }()
    
    @objc
    private func goToGameScene() {
        GameManager.shared.currentGas = GameManager.shared.maxGas
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
