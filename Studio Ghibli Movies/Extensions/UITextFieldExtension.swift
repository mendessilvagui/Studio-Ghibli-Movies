//
//  UITextFieldExtension.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 20/08/21.
//

import UIKit

extension UITextField {

    enum Constants {
        static let passwordMaxLenth = 16
    }

    var textOrEmpty: String {
        return text ?? ""
    }
}
