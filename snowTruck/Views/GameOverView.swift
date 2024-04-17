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
        
        addSubview(mainButton)
        addSubview(secondaryButtonOne)
        addSubview(secondaryButtonTwo)
    }
    
    private func setUpConstraints() {
        background.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width * 0.07).isActive = true
        background.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIScreen.main.bounds.width * 0.07).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        } else {
            background.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.15).isActive = true
            background.bottomAnchor.constraint(equalTo: background.topAnchor, constant: UIScreen.main.bounds.height * 0.55).isActive = true
        }

        mainButton.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        mainButton.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        
        secondaryButtonOne.leadingAnchor.constraint(equalTo: background.leadingAnchor).isActive = true
        secondaryButtonOne.trailingAnchor.constraint(equalTo: background.trailingAnchor).isActive = true
    }
    
    private lazy var background: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundGameOver")
        
        return view
    }()
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if GameManager.shared.rewardedPlayed {
            button.setTitle("RESTART", for: .normal)
        } else {
            button.setTitle("ADS", for: .normal)
        }
        
        button.addTarget(nil, action: #selector(didTapMain), for: .touchUpInside)

        return button
    }()

    private lazy var secondaryButtonOne: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if GameManager.shared.rewardedPlayed {
            button.setTitle("REMOVE ADS", for: .normal)
        } else {
            button.setTitle("RESTART", for: .normal)
        }
        
        button.addTarget(nil, action: #selector(didTapSecondaryOne), for: .touchUpInside)

        return button
    }()

    private lazy var secondaryButtonTwo: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
    
        button.setTitle("HOME", for: .normal)
    
        button.addTarget(nil, action: #selector(didTapSecondaryTwo), for: .touchUpInside)
        
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
