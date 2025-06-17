//
//  FavoritesManager.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 18/06/2025.
//

import Foundation


class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let key = "favoriteMovieIDs"

    private init() {}

    func getFavorites() -> Set<Int> {
        let array = UserDefaultsManager.shared.retrieve(forKey: key) as? [Int] ?? []
        return Set(array)
    }

    func toggleFavorite(id: Int) {
        var favorites = getFavorites()
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        UserDefaultsManager.shared.store(Array(favorites), forKey: key)
    }

    func isFavorite(id: Int) -> Bool {
        return getFavorites().contains(id)
    }
}
