//
//  CharacterCell.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 18.02.2025.
//

import UIKit

protocol CharacterCellDelegate: AnyObject {
    func didTapFavoriteButton(for character: RMCharacter)
}

class CharacterCell: UICollectionViewCell {
    static let reuseID       = Constants.characterCellReuseID
    let avatarImageView      = RMAvatarImageView(frame: .zero)
    let characterNameLabel   = RMTitleLabel(textAlignment: .center, fontSize: 16)
    let actionButton         = RMButton(frame: .zero)
    
    weak var delegate: CharacterCellDelegate?
    private var character: RMCharacter?
    
    private var isFavorite: Bool = false {
        didSet {
            let imageName = isFavorite ? "heart.fill" : "heart"
            actionButton.setImage(UIImage(systemName: imageName), for: .normal)
            actionButton.tintColor = .systemRed
        }
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(character: RMCharacter) {
        self.character = character
        avatarImageView.downloadImage(from: character.image)
        characterNameLabel.text = character.name
        isFavorite = PersistenceManager.isFavorite(character: character)
    }
    
    private func configure() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(characterNameLabel)
        contentView.addSubview(actionButton)
        
        
        actionButton.configuration = .borderless()
        actionButton.configuration?.buttonSize = .mini
        actionButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            characterNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            characterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            characterNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            actionButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: -8),
            actionButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -8),
            actionButton.widthAnchor.constraint(equalToConstant: 24),
            actionButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc func favoriteButtonTapped() {
        guard let character = character else  { return }
        delegate?.didTapFavoriteButton(for: character)
        
    }
    
}
