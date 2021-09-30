//
//  LogInView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import Foundation
import Parse

protocol LogInView: NSObject {
    func showError()
    func close(success: Bool)
}
