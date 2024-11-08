//
//  CoffeeTableView.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 31.10.2024.
//

import UIKit
import CoreLocation

final class LocationsCell: UITableViewCell {
    
    static let reuseIdentifier = "LocationsTableViewCell"
    private let coffeeNameLabel = CoffeeLabel(with: "BEDOEV COFFEE", size: 21, weight: .bold)
    private let coffeeLocationLabel = CoffeeLabel(with: "1 км от вас", size: 14)
    private let containerView = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getDistance(currentLocation: CLLocationCoordinate2D, 
                             latitude: String,
                             longitude: String) -> CLLocationDistance {
        let currentLatitude = currentLocation.latitude
        let currentLongitude = currentLocation.longitude
        let deviceLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        let coffeeLatitude = Double(latitude)
        let coffeeLongitude = Double(longitude)
        
        let coffeePointLocation = CLLocation(latitude: coffeeLatitude!, longitude: coffeeLongitude!)
        let distance = deviceLocation.distance(from: coffeePointLocation) / 1000
        return distance
    }
    
    private func setupUI() {
        coffeeLocationLabel.textColor = .subtextBrown
        
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
        containerView.addSubview(coffeeLocationLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            
            coffeeNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            coffeeNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            coffeeNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            coffeeLocationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            coffeeLocationLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 41),
            coffeeLocationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
        ])
    }
    
    public func set(coffeeName: String, coffeeLocation: Point, currentLocation: CLLocationCoordinate2D?) {
        guard let currentLocation else { return }
        
        coffeeNameLabel.text = coffeeName
        
        let distance = getDistance(currentLocation: currentLocation,
                                   latitude: coffeeLocation.latitude,
                                   longitude: coffeeLocation.longitude)
        let distanceString = String(format: "%.f", distance)
        
        coffeeLocationLabel.text = "\(distanceString) км от вас"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coffeeNameLabel.text = nil
        coffeeLocationLabel.text = nil
    }
}

