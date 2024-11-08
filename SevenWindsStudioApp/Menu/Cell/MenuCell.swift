//
//  MenuCell.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 04.11.2024.
//

import UIKit

final class MenuCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MenuCell"
    
    private let coffeeImageView = UIImageView()
    private let coffeeNameLabel = CoffeeLabel(with: "Капучино", size: 18)
    private let coffeePriceLabel = CoffeeLabel(with: "200 руб", size: 17, weight: .bold)
    let plusMinusView = PlusMinusView(labelHeight: 17,
                                      labelWeight: .regular,
                                      minusImage: "minusButtonLight",
                                      plusImage: "plusButtonLight")
    private let containerView = UIView()
    
    private func downloadImage(with urlString: String) {
        NetworkService.shared.downloadImage(from: urlString) { [weak self] image in
            guard let self else { return }
            self.coffeeImageView.image = image
        }
    }
    
    public func configure(with data: OrderItem) {
        coffeeNameLabel.text = data.name
        coffeePriceLabel.text = "\(data.price) руб"
        plusMinusView.set(count: data.count)
        
        downloadImage(with: data.imageURL)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.cellShadow.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0 , height: 1)
        containerView.layer.shadowOpacity = 1
        containerView.backgroundColor = .systemBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        coffeeNameLabel.textColor = .subtextBrown
        coffeeNameLabel.numberOfLines = 1
        
        coffeeImageView.layer.cornerRadius = 5
        coffeeImageView.translatesAutoresizingMaskIntoConstraints = false
        coffeeImageView.image = UIImage(named: "placeholderImage")
        coffeeImageView.contentMode = .scaleAspectFill
        coffeeImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        coffeeImageView.clipsToBounds = true
    }
    
    private func setupLayout() {
        addSubview(containerView)
        
        containerView.addSubview(coffeeImageView)
        containerView.addSubview(coffeeNameLabel)
        containerView.addSubview(coffeePriceLabel)
        containerView.addSubview(plusMinusView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            coffeeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coffeeImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coffeeImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coffeeImageView.heightAnchor.constraint(equalToConstant: 130),
            
            coffeeNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            coffeeNameLabel.topAnchor.constraint(equalTo: coffeeImageView.bottomAnchor, constant: 6),
            coffeeNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            coffeePriceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            coffeePriceLabel.centerYAnchor.constraint(equalTo: plusMinusView.centerYAnchor),
            coffeePriceLabel.trailingAnchor.constraint(equalTo: plusMinusView.leadingAnchor, constant: -10),
            
            plusMinusView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6),
            plusMinusView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6),
            plusMinusView.widthAnchor.constraint(equalToConstant: 70),
            plusMinusView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coffeeNameLabel.text = nil
        coffeePriceLabel.text = nil
        coffeeImageView.image = nil
    }
}
