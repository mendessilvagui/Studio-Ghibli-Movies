//
//  ChangePasswordViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar()
    }

    private func setUpNavBar() {
        self.title = "Change Password"
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
