//
//  EditUserVIewModel.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 07/10/21.
//

import Foundation

struct EditUserViewModel {
    let name: String
    let nameValidity: InputValidity
    let email: String
    let emailValidity: InputValidity
    let saveButtonEnabled: Bool
}
