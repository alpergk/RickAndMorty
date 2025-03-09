//
//  FavoriteCell.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 26.02.2025.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    static let reuseID = Constants.favoriteCellReuseID
    let avatarImageView = RMAvatarImageView(frame: .zero)
    let characterNameLabel = RMTitleLabel(textAlignment: .left, fontSize: 26)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favorite: RMFavoriteCharacter) {
        avatarImageView.downloadImage(from: favorite.avatarURL)
        characterNameLabel.text = favorite.name
    }
    
    func configure() {
        addSubviews(avatarImageView, characterNameLabel)
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            characterNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            characterNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            characterNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            characterNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
}
