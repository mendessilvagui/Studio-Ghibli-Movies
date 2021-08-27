//
//  SignUpPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import Foundation
import Parse
import RxSwift

struct SignupViewRequest {
    let name: String
    let email: String
    let password: String
    let passwordConfirmation: String
}

struct SignupViewResponse {
    let nameValidity: InputValidity
    let emailValidity: InputValidity
    let passwordValidity: InputValidity
    let passwordConfirmationValidity: InputValidity
    let submitButtonIsEnabled: Bool
}

class SignUpPresenter {

    private weak var view: SignUpView?
    private var allFieldsValid = false
    private let disposeBag = DisposeBag()
    private let details = Details()

    func setView(view: SignUpView) {
        self.view = view
    }

    // MARK: - Presenter methods

    func checkFieldsValidity(withRequest viewRequest: SignupViewRequest) {
        let nameValidity = InputValidator.validateInput(
            rules: [FullNameCheck()],
            input: viewRequest.name
        )
        let emailValidity = InputValidator.validateInput(
            rules: [EmailCheck()],
            input: viewRequest.email
        )
        let passwordValidity = InputValidator.validateInput(
            rules: [PasswordCheck(minLength: 6)],
            input: viewRequest.password
        )
        let passwordConfirmValidity = InputValidator.validateInput(
            rules: [PasswordCheck(minLength: 6), PasswordConfirmationCheck(field: viewRequest.password)],
            input: viewRequest.passwordConfirmation
        )
        switch (nameValidity, emailValidity, passwordValidity, passwordConfirmValidity) {
        case (.valid, .valid, .valid, .valid):
            allFieldsValid = true
        default:
            allFieldsValid = false
        }
        let viewResponse = SignupViewResponse(
            nameValidity: nameValidity,
            emailValidity: emailValidity,
            passwordValidity: passwordValidity,
            passwordConfirmationValidity: passwordConfirmValidity,
            submitButtonIsEnabled: allFieldsValid
        )
        view?.updateView(withResponse: viewResponse)
    }

    func registerUser(withRequest viewRequest: SignupViewRequest) {
        checkFieldsValidity(withRequest: viewRequest)
        guard allFieldsValid else {
            self.view?.showError(FormError.generic)
            return
        }
        let user = User()
        user.username = viewRequest.email
        user.password = viewRequest.password
        user.name = viewRequest.name
        user.email = viewRequest.email
//        user.detailsPointer = details

        RxParse.signUp(user)
            .do(onSuccess: onSignUpSuccess(_:), onError: onSignUpError(_:))
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func onSignUpSuccess(_ user: User) throws {
        self.view?.close(success: true)
    }

    private func onSignUpError(_ error: Error) throws {
        self.view?.showError(error)
    }
}

