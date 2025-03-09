//
//  PersistenceManager.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 25.02.2025.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard //User Default Instance
    enum Keys { static let favorites = "favorites"}
    
    static func retrieveFavorites(completed : @escaping (Result<[RMFavoriteCharacter], RMError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([RMFavoriteCharacter].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    
    static func save(favorites: [RMFavoriteCharacter]) -> RMError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    

    
    static func updateWith(favorite: RMFavoriteCharacter, actionType: PersistenceActionType, completed: @escaping (RMError?) -> Void) {
        retrieveFavorites { result in
            switch result {
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
                completed(save(favorites: favorites))
                
            case .failure(let error):
                completed(error)
            }
            
        }
    }
    
    
    static func isFavorite(character: RMCharacter) -> Bool {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return false
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([RMFavoriteCharacter].self, from: favoritesData)
            return favorites.contains { $0.id == character.id }
        } catch {
            return false
        }
    }
    
}


