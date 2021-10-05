//
//  LogInViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import UIKit
import MaterialComponents

class LogInViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!

    @IBOutlet var emailTextField: MDCOutlinedTextField!
    @IBOutlet var passwordTextField: MDCOutlinedTextField!

    private var emailClearButton = UIButton(type: .custom)
    private var passwordEyeButton = UIButton(type: .custom)

    private let presenter: LogInPresenter
    private let signUpViewController: SignUpViewController
    private let resetPasswordViewController: ResetPasswordViewController

    // MARK: - Init

    init() {
        presenter = LogInPresenter()
        signUpViewController = SignUpViewController()
        resetPasswordViewController = ResetPasswordViewController()
        super.init(nibName: "LogInViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(L10n.initError)
    }

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setView(view: self)
        stylePage()
        styleTextFields()
        setUpHidePasswordButton()

        signUpViewController.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

        self.addKeyboardOberserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //MARK: - SetUp methods

    private func stylePage() {
        Style.styleViewBackground(imageView: imageView)
        Style.styleForm(view: formView, button: logInButton)
    }

    private func styleTextFields() {
        emailTextField.clearButtonTintColor = .darkGray
        emailTextField.styleLoginTextFiels(labelText: "E-mail", iconName: "envelope.fill")
        passwordTextField.styleLoginTextFiels(labelText: "Password", iconName: "lock.fill")
    }

    private func setUpHidePasswordButton() {
        passwordTextField.addButtonToRightView(
            button: passwordEyeButton,
            selector: #selector(showPasswordTapped),
            color: .darkGray,
            target: self
        )
    }

    @objc func showPasswordTapped() {
        passwordTextField.togglePasswordVisibility(for: passwordEyeButton)
        passwordTextField.becomeFirstResponder()
    }

    //MARK: - IBAction methods

    @IBAction func textFieldDoneEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    @IBAction func logInPressed(_ sender: UIButton) {
        let typedEmail = emailTextField.textOrEmpty
        let typedPassword = passwordTextField.textOrEmpty

        if typedEmail.isEmpty || typedPassword.isEmpty {
            self.displayMessage(L10n.registerErrorEmptyFields, withTitle: L10n.error)
        }

        presenter.loginUser(username: typedEmail, password: typedPassword)
    }

    @IBAction func signUpPressed(_ sender: UIButton) {
        self.signUpViewController.showAsAlert(holderView: self)
    }

    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        self.resetPasswordViewController.showAsAlert(holderView: self)
    }
}

//MARK: - Texfields delegate

extension LogInViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            if !text.isEmpty {
                textField.leftViewMode = .never
            } else {
                textField.leftViewMode = .unlessEditing
            }
        }
    }
}

//MARK: - LogInView protocol extension

extension LogInViewController: LogInView {
    func showError(_ error: Error) {
        displayErrorMessage(error)
    }

    func close(success: Bool) {
        self.show(MenuViewController(), sender: self)
        navigationController?.navigationBar.isHidden = false
    }
}

//MARK: - SingupViewControllerDelegate protocol and extension

protocol SignupViewControllerDelegate: AnyObject {
    func userRegistered(email: String?, password: String?)
}

extension LogInViewController: SignupViewControllerDelegate {
    func userRegistered(email: String?, password: String?) {
        emailTextField.text = email
        emailTextField.leftViewMode = .never
        passwordTextField.text = password
        passwordTextField.leftViewMode = .never
    }
}
