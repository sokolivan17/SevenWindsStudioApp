//
//  PlusMinusView.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 03.11.2024.
//

import UIKit

final class PlusMinusView: UIView {
    
    private let minusButton = UIButton()
    private let countLabel = CoffeeLabel(with: "0", size: 16, weight: .bold)
    private let plusButton = UIButton()
    
    var completion: ((Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(labelHeight: CGFloat,
                     labelWeight: UIFont.Weight,
                     minusImage: String,
                     plusImage: String) {
        self.init(frame: .zero)
        countLabel.font = .systemFont(ofSize: labelHeight, weight: labelWeight)
        minusButton.setImage(UIImage(named: minusImage), for: .normal)
        plusButton.setImage(UIImage(named: plusImage), for: .normal)
    }
    
    private func setupMinusButton() {
        let image = UIImage(named: "minusButton")
        minusButton.setImage(image, for: .normal)
        minusButton.tintColor = .buttonBrown
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPlusButton() {
        let image = UIImage(named: "plusButton")
        plusButton.setImage(image, for: .normal)
        plusButton.tintColor = .buttonBrown
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        
        setupMinusButton()
        setupPlusButton()
    }
    
    private func setupLayout() {
        let views = [
            minusButton,
            countLabel,
            plusButton
        ]
        
        views.forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.widthAnchor.constraint(equalToConstant: 10),
            
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 24),
            minusButton.heightAnchor.constraint(equalToConstant: 24),
            minusButton.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -6),
            
            plusButton.leadingAnchor.constraint(equalTo: countLabel.trailingAnchor, constant: 6),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 24),
            plusButton.heightAnchor.constraint(equalToConstant: 24),
            
        ])
    }
    
    public func set(count: Int) {
        countLabel.text = String(count)
    }
    
    @objc private func minusButtonTapped() {
        guard let countLabelText = countLabel.text,
              var currentInt = Int(countLabelText),
              currentInt > 0 else { return }
        
        currentInt -= 1
        countLabel.text = String(currentInt)
        completion?(currentInt)
    }
    
    @objc private func plusButtonTapped() {
        guard let countLabelText = countLabel.text,
              var currentInt = Int(countLabelText) else { return }
        
        currentInt += 1
        countLabel.text = String(currentInt)
        completion?(currentInt)
    }
}
