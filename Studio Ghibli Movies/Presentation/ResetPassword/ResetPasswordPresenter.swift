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

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func sendResetPasswordEmail(email: String) {

        if isValidEmail(email) == true {
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
