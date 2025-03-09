//
//  RMApiResponse.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 18.02.2025.
//

import Foundation

// MARK: - API Response Models

struct RMAPIResponse<T: Decodable>: Decodable {
    let info: RMInfo
    let results: [T]
}

// MARK: - Pagination Info

struct RMInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Character Model

struct RMCharacter: Codable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: RMOrigin
    let location: RMLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Origin Model

struct RMOrigin: Codable, Hashable {
    let name: String
    let url: String
}

// MARK: - Location Model

struct RMLocation: Codable, Hashable {
    let name: String
    let url: String
}

// MARK: - Episode Model

struct RMEpisode: Decodable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}

// MARK: - Location Detail Model

struct RMLocationDetail: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
