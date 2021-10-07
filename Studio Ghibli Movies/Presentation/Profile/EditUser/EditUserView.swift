//
//  EditUserView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import Foundation

protocol EditUserView: AnyObject {
    func showProgress()
    func hideProgress()
    func updateView(withViewModel viewModel: EditUserViewModel)
    func showSuccessMessage()
    func showError(_ error: Error)
    func redirectToLoginScreen()    
}
