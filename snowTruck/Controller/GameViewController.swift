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
                
                sceneNode.goBack = {
                    GameManager.shared.currentCoins = 0
                    GameManager.shared.currentDistance = 0
                    GameManager.shared.currentGas = GameManager.shared.maxGas
                    self.navigationController?.popViewController(animated: false)
                }
                
                view.presentScene(sceneNode)
                view.ignoresSiblingOrder = true
            }
        }
        
        addSubviews()
        setUpConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGasBar), name: Notification.Name("GasBarUpdated"), object: nil)
        
    }
    
    private func addSubviews() {
        view.addSubview(gasBar)
        view.addSubview(gasOverlay)
    }
    
    private func setUpConstraints() {
        gasBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
        gasBar.trailingAnchor.constraint(equalTo: gasBar.leadingAnchor, constant: UIScreen.main.bounds.width * 0.3).isActive = true
        gasBar.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.085).isActive = true
        gasBar.bottomAnchor.constraint(equalTo: gasBar.topAnchor, constant: UIScreen.main.bounds.height * 0.03).isActive = true
        
        gasOverlay.centerXAnchor.constraint(equalTo: gasBar.centerXAnchor).isActive = true
        gasOverlay.centerYAnchor.constraint(equalTo: gasBar.centerYAnchor).isActive = true
    }
    
    // MARK: - UI Elements
    
    private lazy var gasBar: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.trackTintColor = .darkGray
        view.progressTintColor = .red
        view.setProgress(1, animated: false)
        
        return view
    }()
    
    private lazy var gasOverlay: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "gasBar")
        
        return view
    }()
    
    // MARK: - Button Functions
    
    @objc
    private func updateGasBar() {
        let progress = Float(GameManager.shared.currentGas) / Float(GameManager.shared.maxGas)
        gasBar.setProgress(progress, animated: true)
    }
    
    // MARK: -

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
