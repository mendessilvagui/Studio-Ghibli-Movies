//
//  ChangePasswordViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import UIKit
import MBProgressHUD
import MaterialComponents

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: MDCOutlinedTextField!
    @IBOutlet weak var newPasswordTextField: MDCOutlinedTextField!
    @IBOutlet weak var confirmNewPasswordTextField: MDCOutlinedTextField!

    private var oldPasswordEyeButton = UIButton(type: .custom)
    private var newPasswordEyeButton = UIButton(type: .custom)
    private var confirmNewPaswwordEyeButton = UIButton(type: .custom)
    private var saveButton: UIBarButtonItem!

    private var allTextFields = [MDCOutlinedTextField]()

    private let presenter: ChangePasswordPresenter

    //MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setView(view: self)
        setUpNavBar()
        styleTextFields()
        setUpSaveButton()
        setUpHidePasswordsButton()

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
    
    // MARK: - Init

    init() {
        presenter = ChangePasswordPresenter()
        super.init(nibName: "ChangePasswordViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(L10n.initError)
    }
    
    // MARK: - SetUp methods

    private func setUpNavBar() {
        self.setNavBarTitle("Change Password", size: 20)
        self.navigationItem.largeTitleDisplayMode = .never
    }

    private func styleTextFields() {
        allTextFields = [oldPasswordTextField, newPasswordTextField, confirmNewPasswordTextField]

        for textField in allTextFields {
            textField.styleTextField(fieldColor: UIColor(named: L10n.totoroGray), textColor: UIColor(named: L10n.totoroGray))
            textField.leadingAssistiveLabel.text = ""

            switch textField {
            case oldPasswordTextField:
                textField.label.text = "Old Password"
            case newPasswordTextField:
                textField.label.text = "New Password"
            case confirmNewPasswordTextField:
                textField.label.text = "Confirm New Password"
            default:
                textField.label.text = ""
            }
        }
    }

    private func setUpSaveButton() {
        saveButton = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        saveButton.tintColor = .white
        saveButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = saveButton
    }

    private func setUpHidePasswordsButton() {
        oldPasswordTextField.addButtonToRightView(
            button: oldPasswordEyeButton,
            selector: #selector(showOldPasswordTapped),
            color: UIColor(named: L10n.totoroGray),
            target: self
        )

        newPasswordTextField.addButtonToRightView(
            button: newPasswordEyeButton,
            selector: #selector(showNewPasswordTapped),
            color: UIColor(named: L10n.totoroGray),
            target: self
        )

        confirmNewPasswordTextField.addButtonToRightView(
            button: confirmNewPaswwordEyeButton,
            selector: #selector(showConfirmNewPasswordTapped),
            color: UIColor(named: L10n.totoroGray),
            target: self
        )
    }

    //MARK: - Actions

    @objc private func saveButtonTapped() {
        self.view.endEditing(true)
        presenter.onSaveAction(createViewRequest())
    }

    @IBAction func textFieldDoneEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    //MARK: - Helper methods

    @objc func showOldPasswordTapped() {
        oldPasswordTextField.togglePasswordVisibility(for: oldPasswordEyeButton)
    }

    @objc func showNewPasswordTapped() {
        newPasswordTextField.togglePasswordVisibility(for: newPasswordEyeButton)
    }

    @objc func showConfirmNewPasswordTapped() {
        confirmNewPasswordTextField.togglePasswordVisibility(for: confirmNewPaswwordEyeButton)
    }

    @objc func textFieldDidChange(notification: Notification) {
        presenter.checkFieldsValidity(withViewModel: createViewRequest())
    }

    private func createViewRequest() -> ChangePasswordViewModel {
        return ChangePasswordViewModel(
            oldPassword: oldPasswordTextField.textOrEmpty,
            newPassword: newPasswordTextField.textOrEmpty,
            newPasswordValitity: .default,
            newPasswordConfirmation: confirmNewPasswordTextField.textOrEmpty,
            newPasswordConfirmationValidity: .default,
            saveButtonEnabled: false
        )
    }
}

//MARK: - ChangePasswordView protocol extension

extension ChangePasswordViewController: ChangePasswordView {

    func showProgress() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }

    func hideProgress() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    func updateView(withViewModel viewModel: ChangePasswordViewModel) {

        oldPasswordTextField.text = viewModel.oldPassword
        newPasswordTextField.text = viewModel.newPassword
        confirmNewPasswordTextField.text = viewModel.newPasswordConfirmation

        newPasswordTextField.setTextFieldValidity(viewModel.newPasswordValitity)
        confirmNewPasswordTextField.setTextFieldValidity(viewModel.newPasswordConfirmationValidity)
        saveButton.isEnabled = viewModel.saveButtonEnabled

        Update.formError(textField: newPasswordTextField, for: viewModel.newPasswordValitity)
        Update.formError(textField: confirmNewPasswordTextField, for: viewModel.newPasswordConfirmationValidity)
    }

    func showSuccessMessage() {
        self.displaySimpleMessage("Password successfully changed")
    }

    func showError(_ error: Error) {
        if let formError = error as? FormError, formError == FormError.wrongOldPassword {
            self.displaySimpleMessage(formError.localizedDescription)
            return
        }
        self.displayErrorMessage(error)
    }
}
