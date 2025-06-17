//
//  MovieResponse.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

struct MovieResponse: Codable {
    let page: Int
    let results: [MovieDTO]
}
