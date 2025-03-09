//
//  RMAvatarImageView.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 18.02.2025.
//

import UIKit

class RMAvatarImageView: UIImageView {
    
    let cache            = NetworkManager.shared.cache
    let placeholderImage = Images.avatarPlaceholder
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds      = true
        image              = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from url: String) {
        Task {
            image = await NetworkManager.shared.downloadImage(from: url) ?? placeholderImage
        }
    }

}
