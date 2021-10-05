//
//  SignUpView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import Foundation
import Parse

protocol SignUpView: NSObject {
    func showError(_ error: Error)
    func close(email: String?, password: String?)
    func updateView(withResponse: SignupViewResponse)
}
