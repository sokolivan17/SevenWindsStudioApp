//
//  MenuCell.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 04.11.2024.
//

import UIKit
import SnapKit

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
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        coffeeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(130)
        }
        
        coffeeNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(coffeeImageView.snp.bottom).offset(6)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        coffeePriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(plusMinusView.snp.centerY)
            make.trailing.equalTo(plusMinusView.snp.leading).offset(-10)
        }
        
        plusMinusView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-6)
            make.trailing.equalToSuperview().offset(-6)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coffeeNameLabel.text = nil
        coffeePriceLabel.text = nil
        coffeeImageView.image = nil
    }
}
