//
//  NetworkManager.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 18.02.2025.
//

import UIKit

class NetworkManager {
    
    static let shared           = NetworkManager()
    private let baseURL         = Constants.baseURL
    let cache                   = NSCache<NSString, UIImage>()
    let decoder                 = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy  = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    
    
    func getCharacters(page: Int) async throws -> [RMCharacter] {
        
        let endPoint = baseURL + "character/?page=\(page)"
        
        guard let url = URL(string: endPoint) else { throw RMError.invalidResponse }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RMError.invalidResponse
        }
        do {
            let apiResponse = try decoder.decode(RMAPIResponse<RMCharacter>.self, from: data)
            return apiResponse.results
        } catch {
            throw RMError.invalidData
        }
        
    }
    
    
    func getCharacterDetail(for id: Int) async throws -> RMCharacter {
        let endpoint = baseURL + "character/\(id)"
        guard let url = URL(string: endpoint) else { throw RMError.invalidResponse }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RMError.invalidResponse
        }
        
        do {
            return try decoder.decode(RMCharacter.self, from: data)
        } catch {
            throw RMError.invalidData
        }
    }
    
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) { return image}
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
    
 
    
    
    
    
}

