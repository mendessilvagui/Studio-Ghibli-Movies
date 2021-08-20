//
//  LogInViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import UIKit

class LogInViewController: UIViewController, LogInView {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private let presenter: LogInPresenter

    init() {
        presenter = LogInPresenter()
        super.init(nibName: "LogInViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(L10n.initError)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light
        presenter.setView(view: self)
        stylePage()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    func stylePage() {
        Style.styleViewBackground(imageView: imageView)
        Style.styleForm(view: formView, button: logInButton)
    }

    @IBAction func logInPressed(_ sender: UIButton) {
        self.show(MoviesViewController(), sender: self)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func signUpPressed(_ sender: UIButton) {
        self.show(SignUpViewController(), sender: self)
    }

    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
    }
}
