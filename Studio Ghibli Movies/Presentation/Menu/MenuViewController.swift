//
//  MenuViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 05/10/21.
//

import UIKit

class MenuViewController: UITabBarController {

    private var moviesViewController = MoviesViewController()
    private var favoriteMoviesViewController = FavoriteMoviesViewController()
    private var profileViewController = ProfileViewController()
    private var allViewControllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers()
        setUpNavBar()
        setUpTabBar()
        setUpTabBarItems()
    }

    private func setViewControllers() {
        setViewControllers([moviesViewController, favoriteMoviesViewController, profileViewController], animated: true)
    }

    private func setUpNavBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    private func setUpTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "colorTransparent")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        appearance.stackedLayoutAppearance.normal.iconColor = .darkGray
        UITabBar.appearance().tintColor = .white

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }

    private func setUpTabBarItems() {
        allViewControllers = [moviesViewController, favoriteMoviesViewController, profileViewController]

        for viewController in allViewControllers {

            switch viewController {
            case moviesViewController:
                viewController.title = "Movies"
                viewController.tabBarItem.image = UIImage(systemName: "film")
            case favoriteMoviesViewController:
                self.navigationItem.title = "Favorites"
                viewController.title = "Favorites"
                viewController.tabBarItem.image = UIImage(systemName: "heart")
            case profileViewController:
                self.navigationItem.title = "Profile"
                viewController.title = "Profile"
                viewController.tabBarItem.image = UIImage(systemName: "person")
            default:
                break
            }
        }
    }
}
