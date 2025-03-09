//
//  RMItemInfoVC.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 21.02.2025.
//

import UIKit

//protocol ItemnInfoVCDelegate: AnyObject {
//    func didTapGetEpisodes(for char: RMCharacter)
//    func didTapGetStatus()
//}

class RMItemInfoVC: UIViewController {
    
    let actionButton     = RMButton()
    let topContainerView = UIView()
    let itemInfoView     = RMItemInfoView()
    
    
    var character: RMCharacter!
    
    init(character: RMCharacter) {
        super.init(nibName: nil, bundle: nil)
        self.character = character
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        configureActionButton()
        layoutUI()
    }
    
    
    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor    = .secondarySystemBackground
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {}
    
    private func layoutUI() {
        view.addSubviews(topContainerView, actionButton)
        topContainerView.addSubview(itemInfoView)
        for item in [topContainerView, actionButton] {
            item.translatesAutoresizingMaskIntoConstraints = false
        }
     
        
        itemInfoView.pinToEdges(of: topContainerView)
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    
}
