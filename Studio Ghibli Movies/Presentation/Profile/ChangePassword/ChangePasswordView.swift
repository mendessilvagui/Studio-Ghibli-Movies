//
//  ChangePasswordView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import Foundation

protocol ChangePasswordView: AnyObject {
    func showProgress()
    func hideProgress()
    func updateView(withViewModel viewModel: ChangePasswordViewModel)
    func showSuccessMessage()
    func showError(_ error: Error)
}
