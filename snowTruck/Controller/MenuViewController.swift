//
//  MenuViewController.swift
//  snowTruck
//
//  Created by Henrique Semmer on 02/04/24.
//

import UIKit
import AppTrackingTransparency

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setUpConstraints()
        
        GameService.shared.authenticate { error in
            
        }
    }
    
    private func addSubviews() {
        view.addSubview(backgroundImage)
        view.addSubview(titleImage)
        view.addSubview(startButton)
        view.addSubview(gameCenterButton)
    }
    
    private func setUpConstraints() {
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
        navigationController?.pushViewController(GameViewController(), animated: true)
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
