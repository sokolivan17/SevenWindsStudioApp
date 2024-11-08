//
//  CoffeeTextField.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit

final class CoffeeTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(with placeholderString: String) {
        self.init(frame: .zero)
        placeholder = placeholderString
    }
    
    private func configure() {
        layer.cornerRadius = 25
        layer.borderWidth = 2
        layer.borderColor = UIColor.coffeeBrown.cgColor
        
        textColor = .subtextBrown
        tintColor = .subtextBrown
        font = UIFont.systemFont(ofSize: 21)
        backgroundColor = .systemBackground
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 0))
        leftViewMode = .always
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
