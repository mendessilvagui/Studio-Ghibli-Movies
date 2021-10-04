//
//  ResetPasswordViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 01/10/21.
//

import UIKit
import MaterialComponents

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

        stylePage()
        styleTextFields()

        self.addKeyboardOberserver()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func stylePage() {
        Style.styleForm(view: formView, button: sendEmailButton)
    }

    private func styleTextFields() {
        emailTextField.clearButtonTintColor = .darkGray
        emailTextField.styleTextField(fieldColor: .darkGray, textColor: .darkGray)
        emailTextField.label.text = "E-mail"
    }

    @IBAction func dismissResetPasswordWindow(_ sender: UIButton) {
        self.dismissAsAlert(nil)
    }

    @IBAction func sendEmailPressed(_ sender: UIButton) {
        
    }
}
