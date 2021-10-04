//
//  ResetPasswordView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 01/10/21.
//

import Foundation
import Parse

protocol ResetPasswordView {
    func showError(_ error: Error)
    func close(success: Bool)
}
