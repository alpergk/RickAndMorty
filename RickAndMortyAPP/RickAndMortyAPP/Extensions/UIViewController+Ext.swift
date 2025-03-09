//
//  UIViewController+Ext.swift
//  RickAndMortyAPP
//
//  Created by Alper Gok on 22.02.2025.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentRMAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = RMAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle   = .crossDissolve
        present(alertVC, animated: true)
    }
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    func presentDefaultError() {
        let alertVC = RMAlertVC(alertTitle: "Something Went Wrong", message: "We were unable to complete your task. Please try again later.", buttonTitle: "Ok")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle   = .crossDissolve
        present(alertVC, animated: true)
    }
    
    
}
