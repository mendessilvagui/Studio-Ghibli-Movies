//
//  ProfilePresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import Foundation
import Parse
import RxSwift

class ProfilePresenter {

    private weak var view: ProfileView?
    private let disposeBag = DisposeBag()


    func setView(view: ProfileView) {
        self.view = view
    }
    // MARK: Public methods

    func onSelectRegisterData() {
        self.view?.redirectToRegisterData()
    }

    func onSelectChangePassword() {
        self.view?.redirectToChangePasswordScreen()
    }

    func onSelectLogout() {
//        authenticationUseCase.logoutCurrentUser()
//            .subscribe(onCompleted: {
                self.view?.redirectToLoginScreen()
//            })
//            .disposed(by: disposeBag)
    }
}
