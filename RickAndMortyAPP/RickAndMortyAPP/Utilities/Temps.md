#  FavoritesVC

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self else { return }
            guard let error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                if self.favorites.isEmpty {
                    showEmptyStateView(with: "No Favorites?\nAdd some by tapping the heart icon on any character!", in: self.view)
                }
                return
            }
            DispatchQueue.main.async {
                self.presentRMAlert(title: "Unable To Remove", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
# CharacterListVC

    extension CharacterListVC: CharacterCellDelegate {
    func didTapFavoriteButton(for character: RMCharacter) {
        showLoadingView()
        Task {
            defer {dismissLoadingView()}
            do {
                let character = try await NetworkManager.shared.getCharacterDetail(for: character.id)
                addCharacterToFavorites(character: character)
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

# PersistenceManager


    
