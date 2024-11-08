//
//  CoffeeButton.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit

final class CoffeeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(with title: String) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
    }
    
    private func configure() {
        layer.cornerRadius = 25
        setTitleColor(.buttonTextBrown, for: .normal)
        backgroundColor = .buttonBrown
        tintColor = .buttonBrown
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
