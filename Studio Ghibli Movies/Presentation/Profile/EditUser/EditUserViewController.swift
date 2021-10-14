//
//  EditUserViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import UIKit
import MBProgressHUD
import MaterialComponents

class EditUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: MDCOutlinedTextField!
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!

    private var nameClearButton = UIButton(type: .custom)
    private var saveButton: UIBarButtonItem!

    private var allTextFields = [MDCOutlinedTextField]()

    private let presenter: EditUserPresenter

    //MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.setView(view: self)
        presenter.onStart()
        setUpNavBar()
        setUpSaveButton()
        styleTextFields()

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
        presenter = EditUserPresenter()
        super.init(nibName: "EditUserViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(L10n.initError)
    }

    // MARK: - SetUp methods

    private func setUpNavBar() {
        self.setNavBarTitle("Register Data", size: 20)
        self.navigationItem.largeTitleDisplayMode = .never
    }

    private func setUpSaveButton() {
        saveButton = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        saveButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = saveButton
    }

    private func styleTextFields() {
        allTextFields = [nameTextField, emailTextField]

        for textField in allTextFields {
            textField.setTextFieldValidity(.default)
            textField.styleTextField(fieldColor: UIColor(named: L10n.totoroGray), textColor: UIColor(named: L10n.totoroGray))
            textField.leadingAssistiveLabel.text = ""

            switch textField {
            case nameTextField:
                textField.label.text = "Name"
            case emailTextField:
                textField.label.text = "E-mail"
            default:
                textField.label.text = ""
            }
        }
        nameTextField.clearButtonTintColor = UIColor(named: L10n.totoroGray)
        emailTextField.clearButtonTintColor = UIColor(named: L10n.totoroGray)
    }

    //MARK: - Actions

    @objc private func saveButtonTapped() {
        presenter.onSaveAction(createViewRequest())
    }

    @IBAction func textFieldDoneEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    //MARK: - Helper methods

    @objc func textFieldDidChange(notification: Notification) {
        presenter.checkFieldsValidity(withViewModel: createViewRequest())
    }

    private func createViewRequest() -> EditUserViewModel {
        return EditUserViewModel(
            name: nameTextField.textOrEmpty,
            nameValidity: .default,
            email: emailTextField.textOrEmpty,
            emailValidity: .default,
            saveButtonEnabled: false
        )
    }
}

//MARK: - EditUserView protocol extension

extension EditUserViewController: EditUserView {

    func showProgress() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }

    func hideProgress() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    func updateView(withViewModel viewModel: EditUserViewModel) {
        nameTextField.text = viewModel.name
        emailTextField.text = viewModel.email

        nameTextField.setTextFieldValidity(viewModel.nameValidity)
        emailTextField.setTextFieldValidity(viewModel.emailValidity)
        saveButton.isEnabled = viewModel.saveButtonEnabled

        Update.formError(textField: nameTextField, for: viewModel.nameValidity)
        Update.formError(textField: emailTextField, for: viewModel.emailValidity)
    }

    func showSuccessMessage() {
        self.displaySimpleMessage("Profile successfully updated")
    }

    func showError(_ error: Error) {
        self.displayErrorMessage(error)
    }

    func redirectToLoginScreen() {
		show(LogInViewController(), sender: self)
    }
}
