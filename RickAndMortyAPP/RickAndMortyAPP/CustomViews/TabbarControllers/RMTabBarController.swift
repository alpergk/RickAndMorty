//
//  RMTabBarController.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 27.02.2025.
//

import UIKit

class RMTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemBlue
        viewControllers = [createCharacterListNC(), createFavoritesNC()]
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
    }
    
    func createCharacterListNC() -> UINavigationController {
        let characterListVC        = CharacterListVC()
        characterListVC.title      = "Characters"
        characterListVC.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person.3"), selectedImage: UIImage(systemName: "person.3.fill"))
        return UINavigationController(rootViewController: characterListVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC   = FavoritesVC()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        return UINavigationController(rootViewController: favoritesVC)
    }
    

    
    
}
