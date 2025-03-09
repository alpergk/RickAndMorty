//
//  String+Ext.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 22.02.2025.
//

import UIKit

extension String {
    func toDate() -> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX" 
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            return formatter.date(from: self)
        }
}
