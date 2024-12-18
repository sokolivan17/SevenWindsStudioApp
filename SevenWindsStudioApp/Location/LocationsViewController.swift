//
//  LocationsViewController.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit
import SnapKit
import CoreLocation

final class LocationsViewController: UIViewController {
    
    private var locations: [Location] = []
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private let mapButton = CoffeeButton(with: "На карте")
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ближайшие кофейни"
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        
        setupUI()
        setupLayout()
        setupLocation()
        getCoffeeLocations()
    }
    
    private func setupLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
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
    
    private func getCoffeeLocations() {
        let token = returnTokenIfExists()
        
        NetworkService.shared.getLocations(with: token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let coffeePoints):
                self.locations = coffeePoints
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Get locations error: \(error)")
                getNewToken()
            }
        }
    }
    
    private func setupUI() {
        tableView.register(LocationsCell.self, forCellReuseIdentifier: LocationsCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.rowHeight = 77
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let views = [
            tableView,
            mapButton
        ]
        
        views.forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(mapButton.snp.top).offset(-10)
        }
        
        mapButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(19)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.trailing.equalTo(view.snp.trailing).offset(-19)
            make.height.equalTo(48)
        }
    }
    
    @objc private func mapButtonTapped() {
        let viewController = MapViewController(locations: locations)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationsCell.reuseIdentifier, for: indexPath) as? LocationsCell
        else { return UITableViewCell() }
        
        let location = locations[indexPath.row]
        
        cell.set(coffeeName: location.name, coffeeLocation: location.point, currentLocation: currentLocation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let id = locations[indexPath.row].id
        let viewController = MenuViewController(id: id)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LocationsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = location
    }
}
