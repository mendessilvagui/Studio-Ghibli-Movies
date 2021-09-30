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

    func loginUser(username: String, password: String) {

        RxParse.logIn(withUsername: username, password: password)
            .subscribe(onSuccess: { _ in
                guard let currentUser = User.current() else { return }
                PFInstallation.current()?["user"] = currentUser
                PFInstallation.current()?.saveInBackground()
                self.view?.close(success: true)
            }, onFailure: { error in
                self.view?.showError()
            })
            .disposed(by: disposeBag)
    }
}
