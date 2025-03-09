//
//  ViewController.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 18.02.2025.
//

import UIKit



class CharacterListVC: RMDataLoadingVC {
    
    
    
    enum Section { case main }
    
    var characters: [RMCharacter] = []
    var page                      = 1
    var hasMoreCharacters         = true
    var isLoadingMoreCharacters   = false
    var filteredCharacters: [RMCharacter] = []
    var isSearching               = false
    var id : Int!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, RMCharacter>!
    
    
    
    
    
    
    // MARK: -  didLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        configureCollectionView()
        getCharacters(page: page)
        configureDataSource()
        configureSearchController()
        setupFavoritesVCDelegate()
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search for a character"
        searchController.searchResultsUpdater  = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController    = searchController
    }
    
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate        = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseID)
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, RMCharacter>(collectionView: collectionView) { collectionView, indexPath, character in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseID, for: indexPath) as! CharacterCell
            cell.set(character: character)
            cell.delegate = self
            return cell
        }
    }
    
    
    func updateData(on characters: [RMCharacter]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RMCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func updateUI(with characters: [RMCharacter]) {
        if characters.count < 20 {self.hasMoreCharacters = false}
        let newCharacters = characters.filter { character in
            !self.characters.contains { $0.id == character.id }
        }
        self.characters.append(contentsOf: newCharacters)
        
        
        updateData(on: self.characters)
    }
    
    
    func getCharacters(page: Int) {
        showLoadingView()
        isLoadingMoreCharacters = true
        
        Task {
            defer {
                dismissLoadingView()
                isLoadingMoreCharacters = false
            }
            do {
                let characters = try await NetworkManager.shared.getCharacters(page: page)
                updateUI(with: characters)
            } catch {
                if let rmError = error as? RMError {
                    presentRMAlert(title: "We Couldn't Get the Characters !", message: rmError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
    
}

extension CharacterListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY        = scrollView.contentOffset.y
        let contentHeight  = scrollView.contentSize.height
        let heigh          = scrollView.frame.size.height
        if offsetY > contentHeight - heigh {
            guard hasMoreCharacters, !isLoadingMoreCharacters else { return }
            if isSearching {
                return
            }
            page += 1
            getCharacters(page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeArray   = isSearching ? filteredCharacters : characters
        let character     = activeArray[indexPath.item]
        let destVC = CharacterDetailVC(id: character.id)
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
        
    }
    
    func addCharacterToFavorites(character: RMCharacter) {
        let favorite = RMFavoriteCharacter(name: character.name, avatarURL: character.image, id: character.id)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self else { return }
            
            guard let error else {
                DispatchQueue.main.async {
                    self.presentRMAlert(title: "Success!", message: "You have successfully added '\(character.name)' to your favorites!", buttonTitle: "Yehuuu!")
                }
                return
            }
            DispatchQueue.main.async {
                self.presentRMAlert(title: "Something went wrong...", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    // MARK: -  Check this out later 
    func setupFavoritesVCDelegate() {
        guard let tabBarController = self.tabBarController else { return }
        // Find FavoritesVC in the tab bar controller's view controllers
        if let favoritesNC = tabBarController.viewControllers?.first(where: { $0 is UINavigationController && ($0 as! UINavigationController).viewControllers.first is FavoritesVC }) as? UINavigationController,
           let favoritesVC = favoritesNC.viewControllers.first as? FavoritesVC {
            favoritesVC.delegate = self
        }
    }

}


extension CharacterListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredCharacters.removeAll()
            updateData(on: characters)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredCharacters = characters.filter{$0.name.lowercased().contains(filter.lowercased())}
        updateData(on: filteredCharacters)
    }
    
    
    
    
}

extension CharacterListVC: CharacterCellDelegate {
    
func didTapFavoriteButton(for character: RMCharacter) {
    showLoadingView()
    Task {
        defer {dismissLoadingView()}
        do {
            let character = try await NetworkManager.shared.getCharacterDetail(for: character.id)
            addCharacterToFavorites(character: character)
            collectionView.reloadData()
        } catch {
            if let rmError = error as? RMError {
                presentRMAlert(title: "Something went wrong...", message: rmError.rawValue, buttonTitle: "Ok")
            } else {
                presentDefaultError()
            }
        }
    }
}
}

extension CharacterListVC: FavoritesVCDelegate {
    func didRemoveFavorite(id: Int) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
}



