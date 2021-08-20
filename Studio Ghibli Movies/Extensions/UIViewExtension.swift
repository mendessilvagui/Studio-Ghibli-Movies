//
//  UIViewExtension.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 20/08/21.
//

import UIKit

extension UIView {

    func setTextFieldValidity(_ validity: InputValidity) {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        switch validity {
        case .default:
            self.layer.borderColor = ColorCompat.defaultFieldBorderColor.cgColor
        case .valid:
            self.layer.borderColor = ColorCompat.primaryColor.cgColor
        case .invalid:
            self.layer.borderColor = ColorCompat.invalidFieldColor.cgColor
        }
    }
}
