//
//  UIViewController + Extension.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 08.11.2024.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
