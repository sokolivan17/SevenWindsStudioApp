//
//  MenuViewController.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit

final class MenuViewController: UIViewController {
    
    private var selectedItems: [OrderItem] = []
    
    private var collectionView: UICollectionView!
    var menuItems: [OrderItem]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let menuButton = CoffeeButton(with: "Перейти к оплате")
    private var id: Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Меню"
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        
        setupUI()
        setupLayout()
    }
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuItems?.removeAll()
        getMenu(for: id)
    }
    
    private func setupUI() {
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        setupCollectionView()
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(menuButton)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: menuButton.topAnchor, constant: -10),
            
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19),
            menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19),
            menuButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func returnTokenIfExists() -> String {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            getNewToken()
            return ""
        }
        return token
    }
    
    private func getNewToken() {
        let navigationController = UINavigationController(rootViewController: LoginViewController())
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func getMenu(for id: Int) {
        let token = returnTokenIfExists()
        
        NetworkService.shared.getMenu(with: token, for: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let menuItems):
                self.menuItems = menuItems.map({ item in
                    OrderItem(id: item.id,
                              name: item.name,
                              price: item.price,
                              count: 0,
                              imageURL: item.imageURL)
                })
            case .failure(let error):
                print("Get menu error: \(error)")
                getNewToken()
            }
        }
    }
    
    @objc private func menuButtonTapped() {
        guard !selectedItems.isEmpty else { return }
        let viewController = OrderViewController(selectedCards: selectedItems)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupCollectionView() {
        let layout = createCollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalHeight(1))
            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1 / 3))
            let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [layoutItem])
            
            let sectionLayout = NSCollectionLayoutSection(group: layoutGroup)
            return sectionLayout
        }
    }
    
    private func addMenuItemModel(menuItem: OrderItem, counter: Int) {
        self.selectedItems.append(
            OrderItem(id: menuItem.id,
                      name: menuItem.name,
                      price: menuItem.price,
                      count: counter,
                      imageURL: menuItem.imageURL)
        )
    }
}

extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.reuseIdentifier, for: indexPath) as? MenuCell,
              let menuItems
        else { return UICollectionViewCell() }
        
        let menuItem = menuItems[indexPath.item]
        cell.configure(with: menuItem)
        
        cell.plusMinusView.completion = { [weak self] counter in
            guard let self else { return }
            
            if self.selectedItems.isEmpty {
                addMenuItemModel(menuItem: menuItem, counter: counter)
                
            } else if counter == 0 {
                self.selectedItems.removeAll(where: { $0.id == menuItem.id })
                
            } else if self.selectedItems.contains(where: { $0.id == menuItem.id }) {
                self.selectedItems.removeAll(where: { $0.id == menuItem.id })
                addMenuItemModel(menuItem: menuItem, counter: counter)
            } else {
                addMenuItemModel(menuItem: menuItem, counter: counter)
            }
        }
        return cell
    }
}
