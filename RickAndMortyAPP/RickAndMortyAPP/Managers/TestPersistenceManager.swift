//
//  TestPersistenceManager.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 10.03.2025.
//

import UIKit

protocol PersistenceService {
    func retrieveFavorites() -> Result<[RMFavoriteCharacter], RMError>
    func save(favorites: [RMFavoriteCharacter]) -> RMError?
}


class UserDefaultsPersistence: PersistenceService {
    private let defaults = UserDefaults.standard
    private enum Keys { static let favorites = "favorites" }

    func retrieveFavorites() -> Result<[RMFavoriteCharacter], RMError> {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return .success([])
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([RMFavoriteCharacter].self, from: favoritesData)
            return .success(favorites)
        } catch {
            return .failure(.unableToFavorite)
        }
    }

    func save(favorites: [RMFavoriteCharacter]) -> RMError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}


class TestPersistenceManager {
    private let storage: PersistenceService

    init(storage: PersistenceService = UserDefaultsPersistence()) {
        self.storage = storage
    }

    func updateWith(favorite: RMFavoriteCharacter, actionType: PersistenceActionType, completed: @escaping (RMError?) -> Void) {
        switch storage.retrieveFavorites() {
        case .success(var favorites):
            switch actionType {
            case .add:
                guard !favorites.contains(favorite) else {
                    completed(.alreadyInFavorites)
                    return
                }
                favorites.append(favorite)
            case .remove:
                favorites.removeAll { $0.id == favorite.id }
            }
            completed(storage.save(favorites: favorites))
            
        case .failure(let error):
            completed(error)
        }
    }

    func isFavorite(character: RMCharacter) -> Bool {
        switch storage.retrieveFavorites() {
        case .success(let favorites):
            return favorites.contains { $0.id == character.id }
        case .failure:
            return false
        }
    }
}
