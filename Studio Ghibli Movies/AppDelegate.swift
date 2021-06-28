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

        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "d2frdirPKmh2OC5STRU4AdRYHkHKelZZB1UiBwEC"
            $0.clientKey = "bgUpLtYqHwES7ZWyOMtXXbI92ZspcKkXanuzKTSt"
            $0.server = "https://parseapi.back4app.com/"
        }
        Parse.initialize(with: parseConfig)

        return true
    }
}

