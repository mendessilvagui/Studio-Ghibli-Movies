//
//  RegisterDataViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import UIKit

class RegisterDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavBar()
    }

    private func setUpNavBar() {
        self.title = "Register Data"
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
