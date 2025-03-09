//
//  Constant.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 20.02.2025.
//

import UIKit

enum SFSymbols {
    static let location     = UIImage(systemName: "mappin.and.ellipse")
    static let episodes     = UIImage(systemName: "play.square.stack")
    static let status       = UIImage(systemName: "calendar.badge.clock")
    static let followers    = UIImage(systemName: "heart")
    static let following    = UIImage(systemName: "person.2")
    static let actionButton = UIImage(systemName: "star.fill")
    static let specie       = UIImage(systemName: "network")
    static let gender       = UIImage(systemName: "person.circle")
}

enum Constants {
    static let characterCellReuseID = "CharacterCell"
    static let favoriteCellReuseID  = "FavoriteCell"
    static let baseURL              = "https://rickandmortyapi.com/api/"
    static let statusURL            = "https://status.rickandmortyapi.com/"
}

enum Images {
    static let avatarPlaceholder = UIImage(named: "avatar-placeholder")
    static let emptyStateLogo    = UIImage(named: "empty-state-logo")
}
