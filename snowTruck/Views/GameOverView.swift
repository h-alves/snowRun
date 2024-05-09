//
//  GameOverView.swift
//  snowTruck
//
//  Created by Henrique Semmer on 11/04/24.
//

import UIKit

class GameOverView: UIView {

    var onMain: (() -> Void)?
    var onSecondaryOne: (() -> Void)?
    var onSecondaryTwo: (() -> Void)?
    
    init(frame: CGRect, onMain: @escaping () -> Void, onSecondaryOne: @escaping () -> Void, onSecondaryTwo: @escaping () -> Void) {
        super.init(frame: frame)
        
        self.onMain = onMain
        self.onSecondaryOne = onSecondaryOne
        self.onSecondaryTwo = onSecondaryTwo
        
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
        addSubview(gameOverLabel)
        
        addSubview(scoreLabel)
        addSubview(scoreText)
        
        addSubview(highscoreLabel)
        addSubview(highscoreText)
        
        addSubview(mainButton)
        addSubview(secondaryButtonOne)
        addSubview(secondaryButtonTwo)
    }
    
    private func setUpConstraints() {
        background.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width * 0.08).isActive = true
        background.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIScreen.main.bounds.width * 0.08).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            background.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.27).isActive = true
            background.bottomAnchor.constraint(equalTo: background.topAnchor, constant: UIScreen.main.bounds.height * 0.6).isActive = true
        } else {
            background.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.32).isActive = true
            background.bottomAnchor.constraint(equalTo: background.topAnchor, constant: UIScreen.main.bounds.height * 0.53).isActive = true
        }
        
        gameOverLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: UIScreen.main.bounds.width * 0.01).isActive = true
        gameOverLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.01).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            gameOverLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
            gameOverLabel.bottomAnchor.constraint(equalTo: gameOverLabel.topAnchor, constant: UIScreen.main.bounds.height * 0.07).isActive = true
        } else {
            gameOverLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
            gameOverLabel.bottomAnchor.constraint(equalTo: gameOverLabel.topAnchor, constant: UIScreen.main.bounds.height * 0.07).isActive = true
        }
        
        // MARK: - Score
        
        scoreLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: UIScreen.main.bounds.width * 0.23).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.23).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            scoreLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: UIScreen.main.bounds.height * 0.13).isActive = true
            scoreLabel.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: UIScreen.main.bounds.height * 0.036).isActive = true
        } else {
            scoreLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: UIScreen.main.bounds.height * 0.13).isActive = true
            scoreLabel.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: UIScreen.main.bounds.height * 0.036).isActive = true
        }
        
        scoreText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            scoreText.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.005).isActive = true
        } else {
            scoreText.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: UIScreen.main.bounds.height * 0.005).isActive = true
        }
        
        // MARK: - Highscore
        
        highscoreLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: UIScreen.main.bounds.width * 0.18).isActive = true
        highscoreLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.18).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            highscoreLabel.topAnchor.constraint(equalTo: scoreText.bottomAnchor, constant: UIScreen.main.bounds.height * 0.025).isActive = true
            highscoreLabel.bottomAnchor.constraint(equalTo: highscoreLabel.topAnchor, constant: UIScreen.main.bounds.height * 0.038).isActive = true
        } else {
            highscoreLabel.topAnchor.constraint(equalTo: scoreText.bottomAnchor, constant: UIScreen.main.bounds.height * 0.025).isActive = true
            highscoreLabel.bottomAnchor.constraint(equalTo: highscoreLabel.topAnchor, constant: UIScreen.main.bounds.height * 0.036).isActive = true
        }
        
        highscoreText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            highscoreText.topAnchor.constraint(equalTo: highscoreLabel.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.01).isActive = true
        } else {
            highscoreText.topAnchor.constraint(equalTo: highscoreLabel.bottomAnchor, constant: -UIScreen.main.bounds.height * 0.01).isActive = true
        }
        
        // MARK: - Buttons
        
        secondaryButtonOne.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -UIScreen.main.bounds.width * 0.02).isActive = true
        secondaryButtonOne.leadingAnchor.constraint(equalTo: secondaryButtonOne.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.16).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            secondaryButtonOne.topAnchor.constraint(equalTo: highscoreText.bottomAnchor, constant: UIScreen.main.bounds.height * 0.03).isActive = true
            secondaryButtonOne.bottomAnchor.constraint(equalTo: secondaryButtonOne.topAnchor, constant: UIScreen.main.bounds.height * 0.075).isActive = true
        } else {
            secondaryButtonOne.topAnchor.constraint(equalTo: highscoreText.bottomAnchor, constant: UIScreen.main.bounds.height * 0.03).isActive = true
            secondaryButtonOne.bottomAnchor.constraint(equalTo: secondaryButtonOne.topAnchor, constant: UIScreen.main.bounds.height * 0.06).isActive = true
        }
        
        secondaryButtonTwo.leadingAnchor.constraint(equalTo: centerXAnchor, constant: UIScreen.main.bounds.width * 0.02).isActive = true
        secondaryButtonTwo.trailingAnchor.constraint(equalTo: secondaryButtonTwo.leadingAnchor, constant: UIScreen.main.bounds.width * 0.16).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            secondaryButtonTwo.topAnchor.constraint(equalTo: highscoreText.bottomAnchor, constant: UIScreen.main.bounds.height * 0.03).isActive = true
            secondaryButtonTwo.bottomAnchor.constraint(equalTo: secondaryButtonTwo.topAnchor, constant: UIScreen.main.bounds.height * 0.075).isActive = true
        } else {
            secondaryButtonTwo.topAnchor.constraint(equalTo: highscoreText.bottomAnchor, constant: UIScreen.main.bounds.height * 0.03).isActive = true
            secondaryButtonTwo.bottomAnchor.constraint(equalTo: secondaryButtonTwo.topAnchor, constant: UIScreen.main.bounds.height * 0.06).isActive = true
        }
        
        mainButton.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: UIScreen.main.bounds.width * 0.04).isActive = true
        mainButton.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.04).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            mainButton.topAnchor.constraint(equalTo: secondaryButtonOne.bottomAnchor, constant: UIScreen.main.bounds.height * 0.05).isActive = true
            mainButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: UIScreen.main.bounds.height * 0.07).isActive = true
        } else {
            mainButton.topAnchor.constraint(equalTo: secondaryButtonOne.bottomAnchor, constant: UIScreen.main.bounds.height * 0.027).isActive = true
            mainButton.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: UIScreen.main.bounds.height * 0.05).isActive = true
        }
    }
    
    private lazy var background: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundGameOver")
        
        return view
    }()
    
    private lazy var gameOverLabel: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "gameOverTitle")
        
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
    
    private lazy var highscoreLabel: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "bestScore")
        
        return view
    }()
    
    private lazy var highscoreText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "\(Int(GameManager.shared.highestDistance)) km"
        view.textColor = .white
        view.font = UIFont(name: "UpheavalTT-BRK-", size: 32)
        
        return view
    }()

    private lazy var secondaryButtonOne: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if GameManager.shared.rewardedPlayed {
            button.setImage(UIImage(named: "removeAds"), for: .normal)
        } else {
            button.setImage(UIImage(named: "restart"), for: .normal)
        }
        
        button.addTarget(nil, action: #selector(didTapSecondaryOne), for: .touchUpInside)

        return button
    }()

    private lazy var secondaryButtonTwo: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
    
        button.setImage(UIImage(named: "home"), for: .normal)
    
        button.addTarget(nil, action: #selector(didTapSecondaryTwo), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if GameManager.shared.rewardedPlayed {
            button.setImage(UIImage(named: "playAgain"), for: .normal)
        } else {
            button.setImage(UIImage(named: "revive"), for: .normal)
        }
        
        button.addTarget(nil, action: #selector(didTapMain), for: .touchUpInside)

        return button
    }()
    
    @objc private func didTapMain() {
        onMain?()
    }
    
    @objc private func didTapSecondaryOne() {
        onSecondaryOne?()
    }
    
    @objc private func didTapSecondaryTwo() {
        onSecondaryTwo?()
    }

}
