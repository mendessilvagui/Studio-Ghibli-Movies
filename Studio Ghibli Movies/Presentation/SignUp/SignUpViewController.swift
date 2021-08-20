//
//  SignUpViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import UIKit

class SignUpViewController: UIViewController, SignUpView {
    
    func showError(_ error: Error) {
    }

    func showProgress() {

    }

    func close(success: Bool) {

    }

    func updateView(withResponse: SignupViewResponse) {
      
    }


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    private let presenter: SignUpPresenter
    init() {
        presenter = SignUpPresenter()
        super.init(nibName: "SignUpViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(L10n.initError)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.isHidden = true

        presenter.setView(view: self)
        stylePage()
    }

    func stylePage() {
        Style.styleViewBackground(imageView: imageView)
        Style.styleForm(view: formView, button: signUpButton)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        self.show(MoviesViewController(), sender: self)
        navigationController?.navigationBar.isHidden = false
    }
}
