//
//  ResetPasswordPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 01/10/21.
//

import Foundation
import Parse
import RxSwift

class ResetPasswordPresenter {

    private weak var view: ResetPasswordView?
    private let disposeBag = DisposeBag()
    private var users = [User]()
    private var isEmailValid = false

    func setView(view: ResetPasswordView) {
        self.view = view
    }

    //MARK: - Public methods

    private func checkEmailValidity(_ email: String) -> InputValidity {
        let emailValidity = InputValidator.validateInput(
            rules: [EmailCheck()],
            input: email
        )
        return emailValidity
    }

    func sendResetPasswordEmail(email: String) {
        if checkEmailValidity(email) == .valid {
            self.view?.onValidEmail()
            RxParse.resetPassword(for: email)
                .do(onError:{ error in
                    self.view?.showError(error)
                }, onCompleted: {
                    self.view?.onEmailSent()
                })
                    .subscribe()
                    .disposed(by: disposeBag)
        } else {
            self.view?.onInvalidEmail()
        }
    }
}
