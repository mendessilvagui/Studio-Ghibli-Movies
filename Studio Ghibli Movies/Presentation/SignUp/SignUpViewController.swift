//
//  SignUpViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import UIKit
import MBProgressHUD
import MaterialComponents

class SignUpViewController: UIViewController{

    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet var nameTextField: MDCOutlinedTextField!
    @IBOutlet var emailTextField: MDCOutlinedTextField!
    @IBOutlet var passwordTextField: MDCOutlinedTextField!
    @IBOutlet var confirmPasswordTextField: MDCOutlinedTextField!

    private var passwordsFields = [MDCOutlinedTextField]()
    private var allTextFields = [MDCOutlinedTextField]()

    private var nameClearButton = UIButton(type: .custom)
    private var emailClearButton = UIButton(type: .custom)
    private var passwordEyeButton = UIButton(type: .custom)
    private var confirmPaswwordEyeButton = UIButton(type: .custom)

    private let presenter: SignUpPresenter
    weak var delegate: SignupViewControllerDelegate?

    // MARK: - Init

    init() {
        presenter = SignUpPresenter()
        super.init(nibName: "SignUpViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(L10n.initError)
    }

    //MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.isHidden = true

        presenter.setView(view: self)
        stylePage()
        styleTextFields()
        setUpHidePasswordsButton()
        self.addKeyboardOberserver()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidChange(notification:)),
            name: MDCOutlinedTextField.textDidChangeNotification,
            object: nil
        )
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - SetUp methods

    private func stylePage() {
        Style.styleForm(view: formView, button: signUpButton)
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = .lightGray
    }

    private func styleTextFields() {
        allTextFields = [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField]

        for textField in allTextFields {
            textField.styleTextField(fieldColor: .darkGray, textColor: .darkGray)
            textField.leadingAssistiveLabel.text = ""

            switch textField {
            case nameTextField:
                textField.label.text = "Name"
            case emailTextField:
                textField.label.text = "E-mail"
            case passwordTextField:
                textField.label.text = "Password"
            case confirmPasswordTextField:
                textField.label.text = "Confirm Password"
            default:
                textField.label.text = ""
            }
        }

        nameTextField.clearButtonTintColor = UIColor.darkGray
        emailTextField.clearButtonTintColor = UIColor.darkGray
    }

    private func setUpHidePasswordsButton() {
        passwordTextField.addButtonToRightView(
            button: passwordEyeButton,
            selector: #selector(showPasswordTapped),
            color: .darkGray,
            target: self
        )
        passwordTextField.delegate = self

        confirmPasswordTextField.addButtonToRightView(
            button: confirmPaswwordEyeButton,
            selector: #selector(showConfirmPasswordTapped),
            color: .darkGray,
            target: self
        )
        confirmPasswordTextField.delegate = self
    }

    //MARK: - IBAction methods

    @IBAction func dismissRegisterWindow(_ sender: UIButton) {
        self.dismissAsAlert(nil)
    }

    @IBAction func textFieldDoneEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    @IBAction func signUpPressed(_ sender: UIButton) {
        presenter.registerUser(withRequest: createViewRequest())
    }

    //MARK: - Helper methods

    @objc func showPasswordTapped() {
        passwordTextField.togglePasswordVisibility(for: passwordEyeButton)
        passwordTextField.becomeFirstResponder()
    }

    @objc func showConfirmPasswordTapped() {
        confirmPasswordTextField.togglePasswordVisibility(for: confirmPaswwordEyeButton)
        confirmPasswordTextField.becomeFirstResponder()
    }

    @objc func textFieldDidChange(notification: Notification) {
        presenter.checkFieldsValidity(withRequest: createViewRequest())
    }

    private func createViewRequest() -> SignupViewRequest {
        return SignupViewRequest(
            name: nameTextField.textOrEmpty,
            email: emailTextField.textOrEmpty,
            password: passwordTextField.textOrEmpty,
            passwordConfirmation: confirmPasswordTextField.textOrEmpty
        )
    }

    private func updateFormError(textField: MDCOutlinedTextField, for validity: InputValidity) {
        switch validity {
        case .default:
            textField.leadingAssistiveLabel.text = ""
        case .valid:
            textField.leadingAssistiveLabel.text = ""
        case .invalid(error: let error):
            textField.leadingAssistiveLabel.text = error.localizedDescription
        }
    }
}

//MARK: - Textfields delegate

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength = 16
        let currentText = textField.textOrEmpty

        guard let textRange = Range(range, in: currentText) else { return false }

        let newString = currentText.replacingCharacters(in: textRange, with: string)
        return newString.count <= maxLength
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
}

//MARK: - SignUpView protocol extension

extension SignUpViewController: SignUpView {

    func showError(_ error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }

    func close(success: Bool, email: String?, password: String?) {
        for textField in allTextFields {
            textField.text = ""
        }
        delegate?.userRegistered(email: email, password: password)
        presenter.checkFieldsValidity(withRequest: createViewRequest())
        self.dismissAsAlert(nil)
    }

    func updateView(withResponse viewResponse: SignupViewResponse) {

        nameTextField.setTextFieldValidity(viewResponse.nameValidity)
        emailTextField.setTextFieldValidity(viewResponse.emailValidity)
        passwordTextField.setTextFieldValidity(viewResponse.passwordValidity)
        confirmPasswordTextField.setTextFieldValidity(viewResponse.passwordConfirmationValidity)

        signUpButton.isEnabled = viewResponse.submitButtonIsEnabled
        updateFormError(textField: nameTextField, for: viewResponse.nameValidity)
        updateFormError(textField: emailTextField, for: viewResponse.emailValidity)
        updateFormError(textField: passwordTextField, for: viewResponse.passwordValidity)
        updateFormError(textField: confirmPasswordTextField, for: viewResponse.passwordConfirmationValidity)

        if signUpButton.isEnabled {
            signUpButton.backgroundColor = .darkGray
        } else {
            signUpButton.backgroundColor = .lightGray
        }
    }
}
