//
//  UITableView+Ext.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 26.02.2025.
//

import UIKit

extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
