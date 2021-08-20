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
    func showProgress()
    func close(success: Bool)
    func updateView(withResponse: SignupViewResponse)
}
