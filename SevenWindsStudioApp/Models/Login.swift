//
//  Login.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 05.11.2024.
//

import Foundation

struct Login: Decodable {
    let token: String
    let tokenLifetime: Int
}
