//
//  Locations.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 05.11.2024.
//

import Foundation

struct Location: Decodable {
    let id: Int
    let name: String
    let point: Point
}

struct Point: Decodable {
    let latitude: String
    let longitude: String
}
