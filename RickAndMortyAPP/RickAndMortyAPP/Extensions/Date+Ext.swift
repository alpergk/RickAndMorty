//
//  Date+Ext.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 22.02.2025.
//

import Foundation

extension Date {
    func toMonthYearFormat() -> String {
           return self.formatted(.dateTime.month().year())
       }
}
