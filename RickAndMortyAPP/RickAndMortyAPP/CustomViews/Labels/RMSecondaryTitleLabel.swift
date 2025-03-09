//
//  RMSecondaryTitleLabel.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 19.02.2025.
//

import UIKit

class RMSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func configure() {
        textColor                 = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        numberOfLines             = 2
        minimumScaleFactor        = 0.5
        lineBreakMode             = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
