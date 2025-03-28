//
//  RMAlertContainerView.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 22.02.2025.
//

import UIKit

class RMAlertContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor           = .systemBackground
        layer.cornerRadius        = 16
        layer.borderWidth         = 2
        layer.borderColor         = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
