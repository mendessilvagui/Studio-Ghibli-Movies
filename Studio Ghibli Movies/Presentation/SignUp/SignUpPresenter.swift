//
//  SignUpPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import Foundation
import Parse
import RxSwift

class SignUpPresenter {

    private weak var view: SignUpView?
    private let disposeBag = DisposeBag()

    func setView(view: SignUpView) {
        self.view = view
    }

    // MARK: - Presenter methods

}

