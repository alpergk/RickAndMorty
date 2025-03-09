//
//  RMItemInfoView.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 21.02.2025.
//

import UIKit

enum ItemInfoType {
    case episode, createDate
}

class RMItemInfoView: UIView {
    
    let symbolImageView = UIImageView()
    let titleLabel      = RMTitleLabel(textAlignment: .center, fontSize: 28)
    let countLabel      = RMTitleLabel(textAlignment: .center, fontSize: 14)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(symbolImageView, titleLabel, countLabel)
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor   = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -75),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
    }
    
    
    private func convertToDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return formatter.date(from: dateString)
    }
    
    
    private func formatDateToMonthYear(_ date: Date) -> String {
        return date.formatted(.dateTime.month().year())
    }
    
    
    func set(itemInfoType: ItemInfoType, withValue value: Any) {
        switch itemInfoType {
        case .episode:
            guard let count = value as? Int else { return }
            symbolImageView.image = SFSymbols.episodes
            titleLabel.text = "Episodes"
            countLabel.text = String(count)
            
        case .createDate:
            symbolImageView.image = SFSymbols.status
            titleLabel.text = "Created"
            
            if let date = value as? Date {
                countLabel.text = date.toMonthYearFormat()
            } else if let dateString = value as? String, let date = dateString.toDate() {
                countLabel.text = date.toMonthYearFormat()
            } else {
                countLabel.text = "N/A"
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
