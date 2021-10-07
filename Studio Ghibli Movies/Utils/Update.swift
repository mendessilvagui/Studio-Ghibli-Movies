//
//  Update.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 07/10/21.
//

import Foundation
import MaterialComponents

class Update {
    static func formError(textField: MDCOutlinedTextField, for validity: InputValidity) {
        switch validity {
        case .default:
            textField.leadingAssistiveLabel.text = ""
        case .valid:
            textField.leadingAssistiveLabel.text = ""
        case .invalid(error: let error):
            textField.leadingAssistiveLabel.text = error.localizedDescription
        }
    }
}
