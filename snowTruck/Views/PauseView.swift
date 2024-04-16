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
        addSubview(continueButton)
//        addSubview(restartButton)
//        addSubview(menuButton)
    }
    
    private func setUpConstraints() {
        background.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width * 0.07).isActive = true
        background.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIScreen.main.bounds.width * 0.07).isActive = true
        
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width < 18 / 9 {
            
        } else {
            background.topAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.15).isActive = true
            background.bottomAnchor.constraint(equalTo: background.topAnchor, constant: UIScreen.main.bounds.height * 0.55).isActive = true
        }
        
        continueButton.leadingAnchor.constraint(equalTo: background.leadingAnchor).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: background.trailingAnchor).isActive = true
    }
    
    private lazy var background: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundPause")
        
        return view
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "continueButton"), for: .normal)
        button.addTarget(nil, action: #selector(didTapContinue), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var restartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "restartTinyButton"), for: .normal)
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
