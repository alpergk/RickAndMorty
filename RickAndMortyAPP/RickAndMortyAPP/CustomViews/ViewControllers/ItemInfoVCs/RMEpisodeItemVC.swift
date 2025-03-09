//
//  RMEpisodeItemVC.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 21.02.2025.
//

import UIKit

protocol RMEpisodeItemVCDelegate: AnyObject {
    func didTapEpisode(for character: RMCharacter)
}

class RMEpisodeItemVC: RMItemInfoVC {
    
    weak var delegate: RMEpisodeItemVCDelegate!
    
    
    init(character: RMCharacter, delegate: RMEpisodeItemVCDelegate ) {
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
        itemInfoView.set(itemInfoType: .episode, withValue: character.episode.count)
        actionButton.set(color: .systemGreen, title: "Episode", systemImageName: "play.fill")
    }
    
    override func actionButtonTapped() {
        delegate.didTapEpisode(for: character)
    }
}
