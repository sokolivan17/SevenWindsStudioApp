//
//  URLStrings.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 08.11.2024.
//

import Foundation

enum URLStrings {
    static let base = "http://147.78.66.203:3210/"
    static let registerPath = "/auth/register"
    static let loginPath = "/auth/login"
    static let locationPath = "/locations"
    
    static func getMenuPath(id: Int) -> String {
        let idString = String(id)
        let path = "/location/\(idString)/menu"
        return path
    }
}
