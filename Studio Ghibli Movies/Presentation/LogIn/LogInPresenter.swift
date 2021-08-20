//
//  LogInPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import Foundation
import Parse
import RxSwift

class LogInPresenter {

    private weak var view: LogInView?
    private let disposeBag = DisposeBag()

    func setView(view: LogInView) {
        self.view = view
    }

    // MARK: - Presenter methods

}
