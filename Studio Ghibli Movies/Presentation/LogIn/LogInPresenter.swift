//
//  LogInPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import Foundation
import Parse
import RxSwift
import MBProgressHUD

class LogInPresenter {

    private weak var view: LogInView?
    private let disposeBag = DisposeBag()
    private let user = User()

    func setView(view: LogInView) {
        self.view = view
    }

    // MARK: - Presenter methods

    func loginUser() {

        let username = user.username
        let password = user.password

        //RxParse.logIn(withUsername: username, password: password)

//        if typedCpf.isEmpty || typedPassword.isEmpty {
//            self.displayMessage(L10n.registerErrorEmptyFields, withTitle: L10n.allErrorTitle)
//            return
//        }
//
//        if typedCpf.count < 11 {
//            self.displayMessage(L10n.registerErrorInvalidCpf, withTitle: L10n.allErrorTitle)
//            return
//        }
//
//
//        User.logInWithUsername(inBackground: typedCpf, password: typedPassword, block: { (_, error) in
//            guard let currentUser = self.userRepository.getCurrentUser(), error == nil else {
//                MBProgressHUD.hide(for: self.view, animated: true)
//
//                let apiErrorMessage = error?.localizedDescription
//
//                switch apiErrorMessage {
//                case "Invalid username/password.":
//                    self.displayErrorMessage(L10n.registerErrorInvalidCpfOrPassword)
//                case "The Internet connection appears to be offline.":
//                    self.displayErrorMessage(L10n.allErrorOffline)
//                default:
//                    self.displayErrorMessage(L10n.allErrorGeneric)
//                }
//
//                MBProgressHUD.hide(for: self.view, animated: true)
//                return
//            }
//
//            PFInstallation.current()?["user"] = currentUser
//            PFInstallation.current()?.saveInBackground()
//
//            VGParseClient.cleanUpOldSessions(completion: {(exception: Error?) in
//                if let exception = exception {
//                    self.displayErrorMessage(exception.localizedDescription)
//                    MBProgressHUD.hide(for: self.view, animated: true)
//                } else {
//                    self.authenticationUseCase.checkUserRegistrationStage()
//                        .subscribe(onSuccess: { (loginStage: VGLoginStage) in
//                            Router.loginController.userDidCompleteLogin(loginStage: loginStage)
//                            MBProgressHUD.hide(for: self.view, animated: true)
//                        }, onFailure: { (_: Error) in
//                            MBProgressHUD.hide(for: self.view, animated: true)
//                        }).disposed(by: self.disposeBag)
//                }
//            })
//        })
    }

}
