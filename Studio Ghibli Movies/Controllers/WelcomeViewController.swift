//
//  ViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/05/21.

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var allMovies: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allMovies.layer.cornerRadius = 20
    }
    
// MARK: - Hide navbar on title screen
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

