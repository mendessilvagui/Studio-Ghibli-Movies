//
//  UITextFieldExtension.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 20/08/21.
//

import UIKit
import RxSwift

extension UITextField {

    enum Constants {
        static let passwordMaxLenth = 16
    }

    var textOrEmpty: String {
        return text ?? ""
    }

    var clearButton: UIButton? {
        return value(forKey: "clearButton") as? UIButton
    }

    var clearButtonTintColor: UIColor? {
        get {
            return clearButton?.tintColor
        }
        set {
            _ = rx.observe(UIImage.self, "clearButton.imageView.image")
                .take(until: rx.deallocating)
                .subscribe(onNext: { [weak self] _ in
                    let image = self?.clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate)
                    self?.clearButton?.setImage(image, for: .normal)
                })
            clearButton?.tintColor = newValue
        }
    }
}
