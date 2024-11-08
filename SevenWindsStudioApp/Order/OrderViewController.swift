//
//  OrderViewController.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit

final class OrderViewController: UIViewController {
    
    private var selectedCards: [OrderItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let orderButton = CoffeeButton(with: "Оплатить")
    private let orderLabel = CoffeeLabel(with: "Время ожидания заказа\n15 минут!\nСпасибо, что выбрали нас!",
                                         size: 24,
                                         weight: .medium)
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OrderCell.self, forCellWithReuseIdentifier: OrderCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(selectedCards: [OrderItem]) {
        self.selectedCards = selectedCards
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ваш заказ"
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        orderLabel.textAlignment = .center
        
        orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(77))
            let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
            let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
            return sectionLayout
        }
    }
    
    private func setupLayout() {
        let views = [
            collectionView,
            orderLabel,
            orderButton
        ]
        
        views.forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: orderLabel.topAnchor, constant: -10),
            
            orderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            orderLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 486),
            orderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            orderLabel.heightAnchor.constraint(equalToConstant: 87),
            
            orderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            orderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            orderButton.heightAnchor.constraint(equalToConstant: 48),
            orderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addMenuItemModel(menuItem: OrderItem, counter: Int) {
        self.selectedCards.append(
            OrderItem(id: menuItem.id,
                      name: menuItem.name,
                      price: menuItem.price,
                      count: counter,
                      imageURL: menuItem.imageURL)
        )
    }
    
    @objc private func orderButtonTapped() {
        
        
    }
}

extension OrderViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderCell.reuseIdentifier, for: indexPath) as! OrderCell
        let item = selectedCards[indexPath.row]
        cell.set(name: item.name, price: item.price, counter: item.count)
        
        cell.plusMinusView.completion = { [weak self] counter in
            guard let self else { return }
            
            if self.selectedCards.isEmpty {
                addMenuItemModel(menuItem: item, counter: counter)
                
            } else if counter == 0 {
                self.selectedCards.removeAll(where: { $0.id == item.id })
                
            } else if self.selectedCards.contains(where: { $0.id == item.id }) {
                self.selectedCards.removeAll(where: { $0.id == item.id })
                addMenuItemModel(menuItem: item, counter: counter)
            } else {
                addMenuItemModel(menuItem: item, counter: counter)
            }
        }
        return cell
    }
}
