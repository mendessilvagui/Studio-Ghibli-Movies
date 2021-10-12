//
//  StyleBackground.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 20/08/21.
//

import UIKit

class Style {

    static func styleViewBackground(imageView: UIImageView) {
//        let backView = UIView(frame: imageView.bounds)
//        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
//        imageView.addSubview(backView)

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
