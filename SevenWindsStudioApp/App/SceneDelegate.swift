//
//  SceneDelegate.swift
//  SevenWindsStudioApp
//
//  Created by Ваня Сокол on 30.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, 
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        configureNavigationBar()
        window?.rootViewController = UINavigationController(rootViewController: RegistrationViewController())
        window?.makeKeyAndVisible()
    }
    
    private func configureNavigationBar() {
        UINavigationBar.appearance().prefersLargeTitles = false
        UINavigationBar.appearance().backgroundColor = .navbarWhite
        UINavigationBar.appearance().tintColor = .coffeeBrown
        UINavigationBar.appearance().titleTextAttributes =
        [.foregroundColor : UIColor.coffeeBrown,
         .font : UIFont.systemFont(ofSize: 18, weight: .bold)]
        
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            
            navigationBarAppearance.shadowColor = .navBarShadow
            navigationBarAppearance.backgroundColor = .navbarWhite
            navigationBarAppearance.titleTextAttributes =
            [.foregroundColor : UIColor.coffeeBrown,
             .font : UIFont.systemFont(ofSize: 18, weight: .bold)]
            
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
}

