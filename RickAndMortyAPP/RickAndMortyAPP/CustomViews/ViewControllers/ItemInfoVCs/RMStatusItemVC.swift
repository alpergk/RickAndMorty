//
//  RMStatusItemVC.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 21.02.2025.
//

import UIKit

protocol RMStatusItemVCDelegate: AnyObject {
    func didTapStatus(for character: RMCharacter)
}

class RMStatusItemVC: RMItemInfoVC {
    
    weak var delegate: RMStatusItemVCDelegate!
    
    init(character: RMCharacter, delegate: RMStatusItemVCDelegate ) {
        super.init(character: character)
        self.delegate = delegate
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
    
        itemInfoView.set(itemInfoType: .createDate, withValue: character.created)
        actionButton.set(color: .systemPurple, title: "Status", systemImageName: "exclamationmark.triangle")
    }
    
    override func actionButtonTapped() {
        delegate.didTapStatus(for: character)
    }
}
