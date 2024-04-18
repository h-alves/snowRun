//
//  PauseView.swift
//  snowTruck
//
//  Created by Henrique Semmer on 11/04/24.
//

import UIKit

class PauseView: UIView {

    var onContinue: (() -> Void)?
    var onRestart: (() -> Void)?
    var onMenu: (() -> Void)?
    var onConfig: (() -> Void)?
    
    init(frame: CGRect, onContinue: @escaping () -> Void, onRestart: @escaping () -> Void, onMenu: @escaping () -> Void, onConfig: @escaping () -> Void) {
        super.init(frame: frame)
        
        self.onContinue = onContinue
        self.onRestart = onRestart
        self.onMenu = onMenu
        self.onConfig = onConfig
        
        setUpView()
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpView() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    private func addSubviews() {
        addSubview(background)
        addSubview(pauseLabel)
        addSubview(scoreLabel)
        addSubview(scoreText)
        addSubview(restartButton)
        addSubview(menuButton)
        addSubview(continueButton)
    }
    
    private func setUpConstraints() {
        background.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width * 0.08).isActive = true
        background.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIScreen.main.bounds.width * 0.08).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        } else {
            background.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.2).isActive = true
            background.bottomAnchor.constraint(equalTo: background.topAnchor, constant: UIScreen.main.bounds.height * 0.51).isActive = true
        }
        
        pauseLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: UIScreen.main.bounds.width * 0.205).isActive = true
        pauseLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.205).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        } else {
            pauseLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: UIScreen.main.bounds.height * 0.11).isActive = true
            pauseLabel.bottomAnchor.constraint(equalTo: background.topAnchor, constant: UIScreen.main.bounds.height * 0.175).isActive = true
        }
        
        scoreLabel.leadingAnchor.constraint(equalTo: pauseLabel.leadingAnchor, constant: UIScreen.main.bounds.width * 0.04).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: pauseLabel.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.04).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        } else {
            scoreLabel.topAnchor.constraint(equalTo: pauseLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.01).isActive = true
            scoreLabel.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: UIScreen.main.bounds.height * 0.036).isActive = true
        }
        
        scoreText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        } else {
            scoreText.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.005).isActive = true
        }
        
        restartButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -UIScreen.main.bounds.width * 0.02).isActive = true
        restartButton.leadingAnchor.constraint(equalTo: restartButton.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.16).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        } else {
            restartButton.topAnchor.constraint(equalTo: scoreText.bottomAnchor, constant: UIScreen.main.bounds.height * 0.03).isActive = true
            restartButton.bottomAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.055).isActive = true
        }
        
        menuButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: UIScreen.main.bounds.width * 0.02).isActive = true
        menuButton.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: UIScreen.main.bounds.width * 0.16).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        } else {
            menuButton.topAnchor.constraint(equalTo: scoreText.bottomAnchor, constant: UIScreen.main.bounds.height * 0.03).isActive = true
            menuButton.bottomAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.055).isActive = true
        }
        
        continueButton.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: UIScreen.main.bounds.width * 0.16).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.16).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        } else {
            continueButton.topAnchor.constraint(equalTo: background.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.13).isActive = true
            continueButton.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.055).isActive = true
        }
    }
    
    private lazy var background: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundPause")
        
        return view
    }()
    
    private lazy var pauseLabel: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "pauseTitle")
        
        return view
    }()
    
    private lazy var scoreLabel: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "score")
        
        return view
    }()
    
    private lazy var scoreText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "\(Int(GameManager.shared.currentDistance)) km"
        view.textColor = .white
        view.font = UIFont(name: "UpheavalTT-BRK-", size: 32)
        
        return view
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "continue"), for: .normal)
        button.addTarget(nil, action: #selector(didTapContinue), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var restartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "restart"), for: .normal)
        button.addTarget(nil, action: #selector(didTapRestart), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "home"), for: .normal)
        button.addTarget(nil, action: #selector(didTapMenu), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func didTapContinue() {
        onContinue?()
    }
    
    @objc private func didTapRestart() {
        onRestart?()
    }
    
    @objc private func didTapMenu() {
        onMenu?()
    }

}
