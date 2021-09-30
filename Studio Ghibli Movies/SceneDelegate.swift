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

        let mainVC = LogInViewController()
        let nav = UINavigationController(rootViewController: mainVC)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: L10n.navBarColor)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)]
        nav.navigationBar.tintColor = UIColor.white
        nav.navigationBar.standardAppearance = appearance;
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance

        self.window!.rootViewController = nav
        self.window!.makeKeyAndVisible()

        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .dark
        }

        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

