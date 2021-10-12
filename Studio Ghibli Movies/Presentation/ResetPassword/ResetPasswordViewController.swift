//
//  ResetPasswordViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 01/10/21.
//

import UIKit
import MaterialComponents
import MBProgressHUD

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var sendEmailButton: UIButton!
    
    private let presenter: ResetPasswordPresenter

    init() {
        presenter = ResetPasswordPresenter()
        super.init(nibName: "ResetPasswordViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(L10n.initError)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setView(view: self)
        stylePage()
        styleTextFields()

        emailTextField.delegate = self

        self.addKeyboardOberserver()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func stylePage() {
        Style.styleForm(view: formView, button: sendEmailButton)
    }

    private func styleTextFields() {
        emailTextField.clearButtonTintColor = UIColor(named: L10n.totoroGray)
        emailTextField.styleTextField(fieldColor: UIColor(named: L10n.totoroGray), textColor: UIColor(named: L10n.totoroGray))
        emailTextField.label.text = "E-mail"
    }

    @IBAction func dismissResetPasswordWindow(_ sender: UIButton) {
        self.dismissAsAlert(nil)
    }

    @IBAction func textFieldDoneEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    @IBAction func sendEmailPressed(_ sender: UIButton) {
        let typedEmail = emailTextField.textOrEmpty

        if typedEmail.isEmpty {
            displaySimpleMessage("Please enter your e-mail.")
        } else {
            presenter.sendResetPasswordEmail(email: typedEmail)
        }
    }
}

//MARK: - Textfields delegate

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
}

//MARK: - ResetPasswordView protocol extension

extension ResetPasswordViewController: ResetPasswordView {

    func showError(_ error: Error) {
        displayErrorMessage(error)
    }

    func onInvalidEmail() {
        displaySimpleMessage(FormError.email.localizedDescription)
    }

    func onValidEmail() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }

    func onEmailSent() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.showAlert(title: "", message: "An email was sent with the necessary steps to change your password!", buttonTitle: L10n.ok) {
            self.emailTextField.text = ""
            self.dismissAsAlert(nil)
        }
    }
}
