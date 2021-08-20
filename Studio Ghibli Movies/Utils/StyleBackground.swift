//
//  StyleBackground.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 20/08/21.
//

import UIKit

class StyleBackground {

    static func styleViewBackground(imageView: UIImageView) {
        let backView = UIView(frame: imageView.bounds)
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        imageView.addSubview(backView)
    }
}
