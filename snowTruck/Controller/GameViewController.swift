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
        
        addSubviews()
        setUpConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGasBar), name: Notification.Name("GasBarUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGameOverView), name: Notification.Name("ShowGameOver"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCoinLabel), name: Notification.Name("CoinLabelUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDistanceLabel), name: Notification.Name("DistanceLabelUpdated"), object: nil)
        
    }
    
    private func addSubviews() {
        view.addSubview(gasBar)
        view.addSubview(gasOverlay)
        view.addSubview(pauseButton)
        view.addSubview(coin)
        view.addSubview(coinLabel)
        view.addSubview(distanceBackground)
        view.addSubview(distanceLabel)
    }
    
    private func setUpConstraints() {
        gasBar.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -UIScreen.main.bounds.width * 0.095).isActive = true
        gasBar.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: UIScreen.main.bounds.width * 0.095).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            gasBar.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.042).isActive = true
            gasBar.bottomAnchor.constraint(equalTo: gasBar.topAnchor, constant: UIScreen.main.bounds.height * 0.035).isActive = true
        } else {
            gasBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.006).isActive = true
            gasBar.bottomAnchor.constraint(equalTo: gasBar.topAnchor, constant: UIScreen.main.bounds.height * 0.032).isActive = true
        }
        
        gasOverlay.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -UIScreen.main.bounds.width * 0.16).isActive = true
        gasOverlay.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: UIScreen.main.bounds.width * 0.16).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            gasOverlay.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.036).isActive = true
            gasOverlay.bottomAnchor.constraint(equalTo: gasOverlay.topAnchor, constant: UIScreen.main.bounds.height * 0.052).isActive = true
        } else {
            gasOverlay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            gasOverlay.bottomAnchor.constraint(equalTo: gasOverlay.topAnchor, constant: UIScreen.main.bounds.height * 0.045).isActive = true
        }
        
        pauseButton.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.15).isActive = true
        pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.03).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            pauseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.036).isActive = true
            pauseButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        } else {
            pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            pauseButton.bottomAnchor.constraint(equalTo: pauseButton.topAnchor, constant: UIScreen.main.bounds.height * 0.055).isActive = true
        }
        
        coin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * 0.03).isActive = true
        coin.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * 0.12).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            coin.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.045).isActive = true
            coin.bottomAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.09).isActive = true
        } else {
            coin.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.005).isActive = true
            coin.bottomAnchor.constraint(equalTo: coin.topAnchor, constant: UIScreen.main.bounds.height * 0.04).isActive = true
        }
        
        coinLabel.leadingAnchor.constraint(equalTo: coin.trailingAnchor, constant: UIScreen.main.bounds.width * 0.0001).isActive = true
        coinLabel.trailingAnchor.constraint(equalTo: coin.trailingAnchor, constant: UIScreen.main.bounds.width * 0.1).isActive = true
        coinLabel.centerYAnchor.constraint(equalTo: coin.centerYAnchor).isActive = true
        
        distanceBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * 0.03).isActive = true
        distanceBackground.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * 0.33).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            distanceBackground.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.08).isActive = true
            distanceBackground.bottomAnchor.constraint(equalTo: distanceBackground.topAnchor, constant: UIScreen.main.bounds.height * 0.05).isActive = true
        } else {
            distanceBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.05).isActive = true
            distanceBackground.bottomAnchor.constraint(equalTo: distanceBackground.topAnchor, constant: UIScreen.main.bounds.height * 0.04).isActive = true
        }
        
        distanceLabel.leadingAnchor.constraint(equalTo: distanceBackground.leadingAnchor, constant: UIScreen.main.bounds.width * 0.05).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: distanceBackground.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.05).isActive = true
        distanceLabel.centerYAnchor.constraint(equalTo: distanceBackground.centerYAnchor).isActive = true
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
    
    private lazy var pauseButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "pauseButton"), for: .normal)
        view.addTarget(nil, action: #selector(showPauseView), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var coin: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "coin")
        
        return view
    }()
    
    private lazy var coinLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Starbirl", size: 16)
        view.text = "00"
        view.textAlignment = .right
        
        return view
    }()
    
    private lazy var distanceLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Starbirl", size: 12)
        view.text = "0 km"
        view.textColor = .white
        view.textAlignment = .right
        
        return view
    }()
    
    private lazy var distanceBackground: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundLabel")
        
        return view
    }()
    
    // MARK: - Button Functions
    
    @objc
    private func updateGasBar() {
        let progress = Float(GameManager.shared.currentGas) / Float(GameManager.shared.maxGas)
        gasBar.setProgress(progress, animated: true)
    }
    
    @objc
    private func updateCoinLabel() {
        coinLabel.text = String(format: "%02d", GameManager.shared.currentCoins)
    }
    
    @objc
    private func updateDistanceLabel() {
        distanceLabel.text = String("\(Int(GameManager.shared.currentDistance)) km")
    }
    
    @objc
    private func showGameOverView() {
        let gameOverView = GameOverView(frame: view.bounds) {
            print("restart")
            self.removeGameOverView()
            
            GameManager.shared.restartGame()
        } onMenu: {
            print("menu")
            GameManager.shared.currentCoins = 0
            GameManager.shared.currentDistance = 0
            GameManager.shared.currentGas = GameManager.shared.maxGas
            self.navigationController?.popToRootViewController(animated: false)
        }
        
        view.addSubview(gameOverView)
    }
    
    @objc
    private func showPauseView() {
        GameManager.shared.pauseGame()
        
        let pauseView = PauseView(frame: self.view.bounds) {
            print("continue")
            self.removePauseView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                GameManager.shared.resumeGame()
            }
        } onRestart: {
            print("restart")
            self.removePauseView()
            
            GameManager.shared.restartGame()
        } onMenu: {
            print("menu")
            GameManager.shared.currentCoins = 0
            GameManager.shared.currentDistance = 0
            GameManager.shared.currentGas = GameManager.shared.maxGas
            self.navigationController?.popToRootViewController(animated: false)
        } onConfig: {
            print("config")
        }
        
        view.addSubview(pauseView)
    }
    
    private func removePauseView() {
        for subview in view.subviews {
            if subview is PauseView {
                subview.removeFromSuperview()
            }
        }
    }
    
    private func removeGameOverView() {
        for subview in view.subviews {
            if subview is GameOverView {
                subview.removeFromSuperview()
            }
        }
    }
    
    private func removeMenuView() {
        for subview in view.subviews {
            if subview is MenuView {
                subview.removeFromSuperview()
            }
        }
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
