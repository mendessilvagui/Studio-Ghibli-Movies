//
//  StyleBackground.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 20/08/21.
//

import UIKit

class Style {

    static func styleViewBackground(imageView: UIImageView) {
		let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = imageView.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		imageView.addSubview(blurEffectView)
    }

    static func styleForm(view: UIView, button: UIButton) {
        view.layer.cornerRadius = 15
        button.layer.cornerRadius = 5
    }
}
