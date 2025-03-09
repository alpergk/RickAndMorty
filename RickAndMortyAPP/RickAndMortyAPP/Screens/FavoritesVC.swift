//
//  EpisodeVC.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 18.02.2025.
//

import UIKit

protocol FavoritesVCDelegate: AnyObject {
    func didRemoveFavorite(id : Int)
}

class FavoritesVC: RMDataLoadingVC {
    weak var delegate: FavoritesVCDelegate?
    
    let tableView = UITableView()
    var favorites: [RMFavoriteCharacter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title                = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.removeExcessCells()
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    
    func updateUI(with favorites: [RMFavoriteCharacter]) {
        if favorites.isEmpty {
            self.showEmptyStateView(with: "No Favorites?\nAdd some by tapping the heart icon on any character!", in: self.view)
        } else {
            self.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }
            
            switch result {
                
            case .success(let favorites):
                self.updateUI(with: favorites)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentRMAlert(title: "Something went wrong..", message: error.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
}


extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC   = CharacterDetailVC(id: favorite.id)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self else { return }
            guard let error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                if self.favorites.isEmpty {
                    showEmptyStateView(with: "No Favorites?\nAdd some by tapping the heart icon on any character!", in: self.view)
                }
                delegate?.didRemoveFavorite(id: favorite.id)
                return
            }
            DispatchQueue.main.async {
                self.presentRMAlert(title: "Unable To Remove", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    
    
}
