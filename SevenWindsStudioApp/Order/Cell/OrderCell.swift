//
//  OrderCell.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 03.11.2024.
//

import UIKit

final class OrderCell: UICollectionViewCell {
    
    static let reuseIdentifier = "OrderTableViewCell"
    
    private let coffeeNameLabel = CoffeeLabel(with: "Капучино", size: 21, weight: .bold)
    private let coffeePriceLabel = CoffeeLabel(with: "200 руб", size: 16)
    let plusMinusView = PlusMinusView(frame: .zero)
    private let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        coffeeNameLabel.numberOfLines = 1
        
        coffeePriceLabel.textColor = .subtextBrown
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .cellBackgrondBrown
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.cellShadow.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0 , height: 2)
        containerView.layer.shadowOpacity = 1
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.addSubview(coffeeNameLabel)
        containerView.addSubview(coffeePriceLabel)
        containerView.addSubview(plusMinusView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            
            coffeeNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            coffeeNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            coffeeNameLabel.trailingAnchor.constraint(equalTo: plusMinusView.leadingAnchor, constant: -10),
            
            coffeePriceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            coffeePriceLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 41),
            coffeePriceLabel.trailingAnchor.constraint(equalTo: plusMinusView.leadingAnchor, constant: -10),
            
            plusMinusView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            plusMinusView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            plusMinusView.heightAnchor.constraint(equalToConstant: 30),
            plusMinusView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    public func set(name: String, price: Int, counter: Int) {
        coffeeNameLabel.text = name
        coffeePriceLabel.text = "\(price) руб"
        plusMinusView.set(count: counter)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coffeeNameLabel.text = nil
        coffeePriceLabel.text = nil
    }
}
