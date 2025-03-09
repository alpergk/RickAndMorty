//
//  RMCharacterInfoHeaderVC.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 19.02.2025.
//

import UIKit

class RMCharacterInfoHeaderVC: UIViewController {
    
    let avatarImageView           = RMAvatarImageView(frame: .zero)
    let charNameLabel             = RMTitleLabel(textAlignment: .left, fontSize: 16)
    let locationLabel             = RMSecondaryTitleLabel(fontSize: 18)
    let locationImageView         = UIImageView()
    let statusLabel               = RMSecondaryTitleLabel(fontSize: 18)
    let statusImageView           = UIImageView()
    let specieLabel               = RMSecondaryTitleLabel(fontSize: 18)
    let specieImageView           = UIImageView()
    let genderLabel               = RMSecondaryTitleLabel(fontSize: 18)
    let genderImageView           = UIImageView()
    var imageViews: [UIImageView] = []
    
    var character: RMCharacter!
    
    init(character: RMCharacter) {
        super.init(nibName: nil, bundle: nil)
        self.character = character
        view.backgroundColor = .systemBackground
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(avatarImageView, charNameLabel, locationImageView, locationLabel, statusImageView, statusLabel, specieImageView, specieLabel, genderImageView, genderLabel)
        layoutUI()
        configureUIElements()
    }
    
    func configureUIElements () {
        avatarImageView.downloadImage(from: character.image)
        charNameLabel.text          = character.name
        
        locationLabel.text          = character.location.name
        locationImageView.image     = SFSymbols.location
        locationImageView.tintColor = .label
        
        statusLabel.text            = character.status
        statusImageView.image       = UIImage(systemName: getStatusAppearance().imageName)
        statusImageView.tintColor   = getStatusAppearance().color
        
        specieLabel.text            = character.species
        specieImageView.image       = SFSymbols.specie
        specieImageView.tintColor   = .label
        
        
        
        genderLabel.text            = character.gender
        genderImageView.image       = SFSymbols.gender
        genderImageView.tintColor   = .label
        
        
        
    }
    
    func getStatusAppearance() -> (imageName: String, color: UIColor) {
        switch character.status.lowercased() {
        case "alive":
            return ("circle.fill", .systemGreen)
        case "dead":
            return ("circle.fill", .systemRed)
        default:
            return ("questionmark.circle.fill", .systemGray)
        }
    }
    
    func layoutUI() {
        imageViews = [locationImageView, statusImageView, specieImageView, genderImageView]
        
        for image in imageViews {
            image.translatesAutoresizingMaskIntoConstraints = false
        }
      
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            charNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            charNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            charNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            charNameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.topAnchor.constraint(equalTo: locationImageView.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            statusImageView.bottomAnchor.constraint(equalTo: locationImageView.topAnchor, constant: -8),
            statusImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            statusImageView.widthAnchor.constraint(equalToConstant: 20),
            statusImageView.heightAnchor.constraint(equalToConstant: 20),
            
            statusLabel.centerYAnchor.constraint(equalTo: statusImageView.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 5),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 20),
            
            specieImageView.bottomAnchor.constraint(equalTo: statusImageView.topAnchor, constant: -8),
            specieImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            specieImageView.widthAnchor.constraint(equalToConstant: 20),
            specieImageView.heightAnchor.constraint(equalToConstant: 20),
            
            specieLabel.centerYAnchor.constraint(equalTo: specieImageView.centerYAnchor),
            specieLabel.leadingAnchor.constraint(equalTo: specieImageView.trailingAnchor, constant: 5),
            specieLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            specieLabel.heightAnchor.constraint(equalToConstant: 20),
            
            genderImageView.bottomAnchor.constraint(equalTo: specieImageView.topAnchor, constant: -8),
            genderImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            genderImageView.widthAnchor.constraint(equalToConstant: 20),
            genderImageView.heightAnchor.constraint(equalToConstant: 20),
            
            genderLabel.centerYAnchor.constraint(equalTo: genderImageView.centerYAnchor),
            genderLabel.leadingAnchor.constraint(equalTo: genderImageView.trailingAnchor, constant: 5),
            genderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            genderLabel.heightAnchor.constraint(equalToConstant: 20),
            
        ])
    }
}
