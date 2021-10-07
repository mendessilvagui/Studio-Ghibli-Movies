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
}
