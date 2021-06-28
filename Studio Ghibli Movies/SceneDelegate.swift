//
//  SceneDelegate.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/05/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let windowScene:UIWindowScene = scene as! UIWindowScene
        self.window = UIWindow(windowScene: windowScene)
        
        let mainVC = MoviesViewController()
        let nav = UINavigationController(rootViewController: mainVC)
    
        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

