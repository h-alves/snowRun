//
//  MenuView.swift
//  snowTruck
//
//  Created by Henrique Semmer on 11/04/24.
//

import UIKit

class MenuView: UIView {

    var onStart: (() -> Void)?
    var onLeaderboard: (() -> Void)?
    
    init(frame: CGRect, onStart: @escaping () -> Void, onLeaderboard: @escaping () -> Void) {
        super.init(frame: frame)
        
        self.onStart = onStart
        self.onLeaderboard = onLeaderboard
        
        setUpView()
        setUpStartButton()
        setUpLeaderboardButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpView() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    private func setUpStartButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.addTarget(nil, action: #selector(didTapStart), for: .touchUpInside)
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setUpLeaderboardButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Leaderboard", for: .normal)
        button.addTarget(nil, action: #selector(didTapLeaderBoard), for: .touchUpInside)
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50)
        ])
    }
    
    @objc private func didTapStart() {
        onStart?()
    }
    
    @objc private func didTapLeaderBoard() {
        onLeaderboard?()
    }
    
}
