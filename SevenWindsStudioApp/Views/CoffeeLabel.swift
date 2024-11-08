//
//  CoffeeLabel.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit

final class CoffeeLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(with textLabel: String,
                     size: CGFloat = 18,
                     weight: UIFont.Weight = .regular) {
        self.init(frame: .zero)
        text = textLabel
        font = UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    private func configure() {
        textColor = .coffeeBrown
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
}
