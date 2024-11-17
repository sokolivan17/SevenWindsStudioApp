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
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
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
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(orderLabel.snp.top).offset(-10)
        }
        
        orderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.top.equalTo(view.snp.top).offset(486)
            make.trailing.equalToSuperview().offset(-13)
            make.height.equalTo(87)
        }
        
        orderButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-19)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
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
