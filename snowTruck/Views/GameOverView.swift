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
    
    init(frame: CGRect, onRestart: @escaping () -> Void, onMenu: @escaping () -> Void) {
        super.init(frame: frame)
        
        self.onRestart = onRestart
        self.onMenu = onMenu
        
        setUpView()
        setUpRestartButton()
        setUpMenuButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpView() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    private func setUpRestartButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Restart", for: .normal)
        button.addTarget(nil, action: #selector(didTapRestart), for: .touchUpInside)
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
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
            button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50)
        ])
    }
    
    @objc private func didTapRestart() {
        onRestart?()
    }
    
    @objc private func didTapMenu() {
        onMenu?()
    }

}
