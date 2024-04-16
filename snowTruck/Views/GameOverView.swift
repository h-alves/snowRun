//
//  GameOverView.swift
//  snowTruck
//
//  Created by Henrique Semmer on 11/04/24.
//

import UIKit

class GameOverView: UIView {

    var onRestart: (() -> Void)?
    var onMenu: (() -> Void)?
    var onAd: (() -> Void)?
    
    init(frame: CGRect, onRestart: @escaping () -> Void, onMenu: @escaping () -> Void, onAd: @escaping () -> Void) {
        super.init(frame: frame)
        
        self.onRestart = onRestart
        self.onMenu = onMenu
        self.onAd = onAd
        
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
        addSubview(restartButton)
        
        if !GameManager.shared.rewardedPlayed {
            addSubview(adButton)
        }
    }
    
    private func setUpConstraints() {
        background.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width * 0.07).isActive = true
        background.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIScreen.main.bounds.width * 0.07).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        } else {
            background.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.15).isActive = true
            background.bottomAnchor.constraint(equalTo: background.topAnchor, constant: UIScreen.main.bounds.height * 0.55).isActive = true
        }
        
        restartButton.leadingAnchor.constraint(equalTo: background.leadingAnchor).isActive = true
        restartButton.trailingAnchor.constraint(equalTo: background.trailingAnchor).isActive = true
        
        if !GameManager.shared.rewardedPlayed {
            adButton.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
            adButton.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        }
    }
    
    private lazy var background: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundGameOver")
        
        return view
    }()
    
    private lazy var restartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "restartButton"), for: .normal)
        button.addTarget(nil, action: #selector(didTapRestart), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "menuTinyButton"), for: .normal)
        button.addTarget(nil, action: #selector(didTapMenu), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var adButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ANUNCIO", for: .normal)
        button.addTarget(nil, action: #selector(didTapAd), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func didTapRestart() {
        onRestart?()
    }
    
    @objc private func didTapMenu() {
        onMenu?()
    }
    
    @objc private func didTapAd() {
        onAd?()
    }

}
