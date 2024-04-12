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
        setUpContinueButton()
        setUpRestartButton()
        setUpMenuButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpView() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    private func setUpContinueButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.addTarget(nil, action: #selector(didTapContinue), for: .touchUpInside)
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setUpRestartButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Restart", for: .normal)
        button.addTarget(nil, action: #selector(didTapRestart), for: .touchUpInside)
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50)
        ])
    }
    
    private func setUpMenuButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Menu", for: .normal)
        button.addTarget(nil, action: #selector(didTapMenu), for: .touchUpInside)
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 100)
        ])
    }
    
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
