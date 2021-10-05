//
//  ProfileViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 05/10/21.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Profile"
    }
}
