//
//  AppDelegate.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/05/21.
//

import UIKit
import Parse

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Thread.sleep(forTimeInterval: 2.0)

        let parseConfig = ParseClientConfiguration {
			$0.applicationId = L10n.applicationId
			$0.clientKey = L10n.clientKey
			$0.server = L10n.server
        }
        Parse.initialize(with: parseConfig)

        return true
    }
}

