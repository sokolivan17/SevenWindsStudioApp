//
//  MapViewController.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit
import SnapKit
import YandexMapsMobile

final class MapViewController: UIViewController {
    
    private let mapView = YMKMapView(frame: .zero, vulkanPreferred: true)!
    private var map: YMKMap!
    
    private var locations: [Location] {
        didSet {
            addPlacemark(for: locations)
            move(to: locations.first)
        }
    }
    
    init(locations: [Location]) {
        self.locations = locations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Карта"
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupLayout()
        addPlacemark(for: locations)
        move(to: locations.first)
    }
    
    private func setupUI() {
        map = mapView.mapWindow.map
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func move(to firstPoint: Location?) {
        guard let firstPoint,
              let latitude = Double(firstPoint.point.latitude),
              let longitude = Double(firstPoint.point.longitude)
        else { return }
        
        let point = YMKPoint(latitude: latitude, longitude: longitude)
        let cameraPosition = YMKCameraPosition(target: point, zoom: 8.0, azimuth: 150.0, tilt: 30.0)
        
        map.move(with: cameraPosition, animation: YMKAnimation(type: .smooth, duration: 1.0))
    }
    
    private func addPlacemark(for points: [Location]) {
        let image = UIImage(named: "placemarkIcon")!
        
        points.forEach { point in
            guard let latitude = Double(point.point.latitude),
                  let longitude = Double(point.point.longitude)
            else { return }
            
            let placemark = map.mapObjects.addPlacemark()
            placemark.geometry = YMKPoint(latitude: latitude,
                                          longitude: longitude)
            placemark.setIconWith(image)
            
            placemark.setTextWithText(
                point.name,
                style: YMKTextStyle(
                    size: 10.0,
                    color: .coffeeBrown,
                    outlineWidth: 1.0,
                    outlineColor: .coffeeBrown,
                    placement: .bottom,
                    offset: 0.0,
                    offsetFromIcon: true,
                    textOptional: false
                )
            )
        }
    }
}
