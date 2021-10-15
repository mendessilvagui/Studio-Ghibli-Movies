//
//  ResetPasswordView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 01/10/21.
//

import Foundation

protocol ResetPasswordView: AnyObject {
    func showError(_ error: Error)
    func onInvalidEmail()
    func onValidEmail()
    func onEmailSent()
}
