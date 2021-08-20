//
//  ColorCompat.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 20/08/21.
//

import UIKit

class ColorCompat {
    static var primaryColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemIndigo
        } else {
            return UIColor(named: "defaultField")!
        }
    }

    // MARK: - TextFields

    static var defaultFieldBorderColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.separator
        } else {
            return UIColor(named: "defaultField")!
        }
    }

    static var invalidFieldColor: UIColor {
        return UIColor(named: "invalidField")!
    }
}
