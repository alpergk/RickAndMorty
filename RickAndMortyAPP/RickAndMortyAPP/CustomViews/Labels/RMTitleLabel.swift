//
//  RMTitlteLabel.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 18.02.2025.
//

import UIKit

class RMTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font          = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    private func configure() {
        textColor                 = .label
        adjustsFontSizeToFitWidth = true
        numberOfLines             = 2
        minimumScaleFactor        = 0.50
        lineBreakMode             = .byTruncatingTail
        
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}
