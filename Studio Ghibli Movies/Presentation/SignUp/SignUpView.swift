//
//  SignUpView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import Foundation

protocol SignUpView: AnyObject {
    func showError(_ error: Error)
    func close(email: String?, password: String?)
    func updateView(withResponse: SignupViewResponse)
}
