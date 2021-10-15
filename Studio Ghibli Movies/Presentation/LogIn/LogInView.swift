//
//  LogInView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import Foundation

protocol LogInView: AnyObject {
    func showError(_ error: Error)
    func close(success: Bool)
}
