//
//  CharacterDetailVC.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 18.02.2025.
//

import UIKit

class CharacterDetailVC: RMDataLoadingVC {
    
    let contentView           = UIView()
    let headerView            = UIView()
    let itemViewOne           = UIView()
    let itemViewTwo           = UIView()
    let scrollView            = UIScrollView()
    var itemViews: [UIView]   = []
    
    
    
    
    var id: Int
    
    
    init(id : Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        layoutUI()
        getCharacterDetail()
        
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1200)
        ])
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        if presentingViewController != nil {
            // If presented modally, dismiss it
            dismiss(animated: true)
        } else if let navigationController = navigationController {
            // If pushed onto a navigation stack, pop it
            navigationController.popViewController(animated: true)
        }
    }
    
    func configureUIElement(with character: RMCharacter) {
        self.add(childVC: RMCharacterInfoHeaderVC(character: character), to: self.headerView)
        self.add(childVC: RMStatusItemVC(character: character, delegate: self), to: self.itemViewOne)
        self.add(childVC: RMEpisodeItemVC(character: character, delegate: self), to: self.itemViewTwo)
    }
    
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func getCharacterDetail() {
        Task {
            do {
                let character  = try await NetworkManager.shared.getCharacterDetail(for: id)
        
                configureUIElement(with: character)
            } catch {
                if let rmError = error as? RMError {
                    presentRMAlert(title: "Something went wrong", message: rmError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
                
            }
        }
    }
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo]
        
        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            itemViewOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            itemViewOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: 20),
            itemViewTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            itemViewTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
        ])
    }
}


extension CharacterDetailVC: RMStatusItemVCDelegate {
    func didTapStatus(for character: RMCharacter) {
        guard let url = URL(string: Constants.statusURL) else {
            presentRMAlert(title: "Invalid URL", message: "The provided URL is invalid", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
}


// TODO: - Implement this feature

extension CharacterDetailVC: RMEpisodeItemVCDelegate {
    func didTapEpisode(for character: RMCharacter) {
        print("Episodes Button tapped")
    }
}


