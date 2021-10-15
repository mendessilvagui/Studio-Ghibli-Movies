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
    private var aboutViewContoller = AboutViewController()
    private var allViewControllers = [UIViewController]()

    //MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers()
        setUpNavBar()
        setUpTabBar()
        setUpTabBarItems()
    }

    //MARK: - SetUp methods

    private func setViewControllers() {
        setViewControllers([moviesViewController, favoriteMoviesViewController, profileViewController, aboutViewContoller], animated: true)
    }

    private func setUpNavBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    private func setUpTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor(named: L10n.totoroGray)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
		appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        UITabBar.appearance().tintColor = .white
        tabBar.standardAppearance = appearance
        tabBar.addShadowToView(color: UIColor.black.cgColor, radius: 5, offset: CGSize(width: 0, height: -5), opacity: 0.5)
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }

    private func setUpTabBarItems() {
        allViewControllers = [moviesViewController, favoriteMoviesViewController, profileViewController, aboutViewContoller]

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
            case aboutViewContoller:
                self.navigationItem.title = "About"
                viewController.title = "About"
                viewController.tabBarItem.image = UIImage(systemName: "info.circle")
            default:
                break
            }
        }
    }
}
