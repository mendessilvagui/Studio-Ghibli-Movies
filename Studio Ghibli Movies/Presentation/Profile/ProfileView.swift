//
//  ProfileView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import Foundation

protocol ProfileView: AnyObject {
    func redirectToEditUser()
    func redirectToChangePasswordScreen()
    func redirectToLoginScreen()
}
