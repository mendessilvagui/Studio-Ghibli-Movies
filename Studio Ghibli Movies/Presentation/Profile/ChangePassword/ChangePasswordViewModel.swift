//
//  ChangePasswordViewModel.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 07/10/21.
//

import Foundation

struct ChangePasswordViewModel {
    let oldPassword: String
    let oldPasswordValidity: InputValidity
    let newPassword: String
    let newPasswordValitity: InputValidity
    let newPasswordConfirmation: String
    let newPasswordConfirmationValidity: InputValidity
    let resetButtonEnabled: Bool
}
