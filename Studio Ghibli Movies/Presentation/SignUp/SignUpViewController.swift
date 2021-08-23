//
//  SignUpViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import UIKit
import MBProgressHUD

class SignUpViewController: UIViewController{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var nameHolder: UIView!
    @IBOutlet weak var emailHolder: UIView!
    @IBOutlet weak var passwordHolder: UIView!
    @IBOutlet weak var confirmPasswordHolder: UIView!
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    private let presenter: SignUpPresenter
    weak var delegate: SignupViewControllerDelegate?

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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidChange(notification:)),
            name: UITextField.textDidChangeNotification,
            object: nil
        )
    }

    func stylePage() {
        errorLabel.text = ""
        Style.styleViewBackground(imageView: imageView)
        Style.styleForm(view: formView, button: signUpButton)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        presenter.registerUser(withRequest: createViewRequest())
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
}

extension SignUpViewController: SignUpView {

    func showError(_ error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }


    func close(success: Bool) {
        self.show(MoviesViewController(), sender: self)
        navigationController?.navigationBar.isHidden = false
        self.delegate?.userRegistered()
    }

    func updateView(withResponse viewResponse: SignupViewResponse) {

        nameHolder.setTextFieldValidity(viewResponse.nameValidity)
        emailHolder.setTextFieldValidity(viewResponse.emailValidity)
        passwordHolder.setTextFieldValidity(viewResponse.passwordValidity)
        confirmPasswordHolder.setTextFieldValidity(viewResponse.passwordConfirmationValidity)

        errorLabel.text = ""
        signUpButton.isEnabled = viewResponse.submitButtonIsEnabled
        updateFormError(for: viewResponse.nameValidity)
        updateFormError(for: viewResponse.emailValidity)
        updateFormError(for: viewResponse.passwordValidity)
        updateFormError(for: viewResponse.passwordConfirmationValidity)

    }

    private func updateFormError(for validity: InputValidity) {
        switch validity {
        case .invalid(error: let error):
            errorLabel.text = error.localizedDescription

        default:
            break
        }
    }
}

protocol SignupViewControllerDelegate: AnyObject {
    func userRegistered()
}
