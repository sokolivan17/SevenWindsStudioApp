//
//  MenuItem.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 05.11.2024.
//

import Foundation

struct MenuItem: Decodable {
    let id: Int
    let name: String
    let imageURL: String
    let price: Int
}
