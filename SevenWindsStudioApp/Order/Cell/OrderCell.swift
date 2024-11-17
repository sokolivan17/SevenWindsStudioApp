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
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        coffeeNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(14)
            make.trailing.equalTo(plusMinusView.snp.leading).offset(-10)
        }
        
        coffeePriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(41)
            make.trailing.equalTo(plusMinusView.snp.leading).offset(-10)
        }

        plusMinusView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
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
