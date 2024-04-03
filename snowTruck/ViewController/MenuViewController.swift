//
//  MenuViewController.swift
//  snowTruck
//
//  Created by Henrique Semmer on 02/04/24.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setUpConstraints()
        
        GameService.shared.authenticate { error in
            GameService.shared.showAccessPoint()
        }
    }
    
    private func addSubviews() {
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(highscoreLabel)
        view.addSubview(coinLabel)
        view.addSubview(startButton)
    }
    
    private func setUpConstraints() {
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height / 3)).isActive = true
        
        highscoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        highscoreLabel.centerYAnchor.constraint(equalTo: titleLabel.topAnchor, constant: (100)).isActive = true
        
        coinLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coinLabel.centerYAnchor.constraint(equalTo: highscoreLabel.topAnchor, constant: (50)).isActive = true
        
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: coinLabel.topAnchor, constant: (100)).isActive = true
    }
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Snow Truck"
        view.textColor = .black
        view.font = view.font.withSize(40)
        
        return view
    }()
    
    private lazy var highscoreLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Highscore: \(Int(GameController.shared.highestDistance))"
        view.textColor = .black
        view.font = view.font.withSize(26)
        
        return view
    }()
    
    private lazy var coinLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Coins: \(Int(GameController.shared.totalCoins))"
        view.textColor = .black
        view.font = view.font.withSize(26)
        
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Start", for: .normal)
        view.setTitleColor(.red, for: .normal)
        view.isEnabled = true
        view.addTarget(self, action: #selector(goToGameScene), for: .touchUpInside)
        
        return view
    }()
    
    @objc
    private func goToGameScene() {
        GameService.shared.hideAccessPoint()
        navigationController?.pushViewController(GameViewController(), animated: true)
    }

}
