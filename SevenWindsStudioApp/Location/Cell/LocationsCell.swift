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
        
        
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(10)
            make.top.equalTo(snp.top)
            make.trailing.equalTo(snp.trailing).offset(-10)
            make.bottom.equalTo(snp.bottom).offset(-6)
        }
        
        coffeeNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(10)
            make.top.equalTo(containerView.snp.top).offset(14)
            make.trailing.equalTo(containerView.snp.trailing).offset(-10)
        }
        
        coffeeLocationLabel.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(10)
            make.top.equalTo(containerView.snp.top).offset(41)
            make.trailing.equalTo(containerView.snp.trailing).offset(-10)
        }
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

