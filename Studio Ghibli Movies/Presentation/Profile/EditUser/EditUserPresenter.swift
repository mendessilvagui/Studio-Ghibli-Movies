//
//  EditUserPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import Foundation
import RxSwift

class EditUserPresenter {

    private weak var view: EditUserView?
    private let disposeBag = DisposeBag()

    func setView(view: EditUserView) {
        self.view = view
    }

    // MARK: Public methods

    func onStart() {
        fetchUserDataAndFillFields()
    }

    func onSaveAction(_ viewModel: EditUserViewModel) {
        guard let currentUser = DataBase.getCurrentUser() else { return }
        currentUser.name = viewModel.name
        currentUser.username = viewModel.email
        view?.showProgress()
        DataBase.saveUser(currentUser)
            .subscribe(onSuccess: { (_: User) in
                self.view?.hideProgress()
                self.view?.showSuccessMessage()
            }, onFailure: { (error: Error) in
                self.view?.hideProgress()
                self.view?.showError(error)
            }).disposed(by: disposeBag)
    }

    func checkFieldsValidity(withViewModel viewModel: EditUserViewModel) {
        var allFieldsValid = false
        let nameValidity = InputValidator.validateInput(
            rules: [FullNameCheck()],
            input: viewModel.name
        )
        let emailValidity = InputValidator.validateInput(
            rules: [EmailCheck()],
            input: viewModel.email
        )

        switch (nameValidity, emailValidity) {
        case (.valid, .valid):
            allFieldsValid = true
        default:
            break
        }

        let response = EditUserViewModel(
            name: viewModel.name,
            nameValidity: nameValidity,
            email: viewModel.email,
            emailValidity: emailValidity,
            saveButtonEnabled: allFieldsValid
        )
        view?.updateView(withViewModel: response)
    }

    // MARK: Private methods

    private func fetchUserDataAndFillFields() {
        guard let currentUser = DataBase.getCurrentUser() else {
            self.view?.redirectToLoginScreen()
            return
        }
        view?.showProgress()
        DataBase.fetchUser(currentUser)
            .subscribe(onSuccess: { (_: User) in
                self.view?.hideProgress()
                let viewModel = EditUserViewModel(
                    name: currentUser.name ?? "",
                    nameValidity: .valid,
                    email: currentUser.username ?? "",
                    emailValidity: .valid,
                    saveButtonEnabled: true
                )
                self.view?.updateView(withViewModel: viewModel)
            }, onFailure: { (error: Error) in
                self.view?.hideProgress()
                self.view?.showError(error)
            }).disposed(by: disposeBag)
    }
}
