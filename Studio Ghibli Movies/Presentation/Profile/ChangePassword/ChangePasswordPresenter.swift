//
//  ChangePasswordPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import Foundation
import RxSwift
import Parse

class ChangePasswordPresenter {

    private weak var view: ChangePasswordView?
    private let disposeBag = DisposeBag()

    func setView(view: ChangePasswordView) {
        self.view = view
    }

    // MARK: Public methods

    func checkFieldsValidity(withViewModel viewModel: ChangePasswordViewModel) {
        var allFieldsValid = false

        let newPasswordValidity = InputValidator.validateInput(
            rules: [PasswordCheck()],
            input: viewModel.newPassword
        )

        let passwordConfirmationValidity = InputValidator.validateInput(
            rules: [PasswordConfirmationCheck(field: viewModel.newPassword)],
            input: viewModel.newPasswordConfirmation
        )

        switch (newPasswordValidity, passwordConfirmationValidity) {
        case (.valid, .valid):
            allFieldsValid = true
        default:
            break
        }

        let response = ChangePasswordViewModel(
            oldPassword: viewModel.oldPassword,
            newPassword: viewModel.newPassword,
            newPasswordValitity: newPasswordValidity,
            newPasswordConfirmation: viewModel.newPasswordConfirmation,
            newPasswordConfirmationValidity: passwordConfirmationValidity,
            saveButtonEnabled: allFieldsValid)
        
        view?.updateView(withViewModel: response)
    }

    func onSaveAction(_ viewModel: ChangePasswordViewModel) {
        let oldPassword = viewModel.oldPassword
        let newPassword = viewModel.newPassword
        view?.showProgress()

        DataBase.changePassword(oldPassword, newPassword)
            .subscribe(onCompleted: {
                self.view?.hideProgress()
                self.view?.showSuccessMessage()
                self.clearPasswordFields()
            }, onError: { (error: Error) in
                self.view?.hideProgress()
                self.view?.showError(error)
            }).disposed(by: disposeBag)
    }

    // MARK: Private methods

    private func clearPasswordFields() {
        let viewModel = ChangePasswordViewModel(
                oldPassword: "",
                newPassword: "",
                newPasswordValitity: .default,
                newPasswordConfirmation: "",
                newPasswordConfirmationValidity: .default,
                saveButtonEnabled: false
        )
        view?.updateView(withViewModel: viewModel)
    }
}
