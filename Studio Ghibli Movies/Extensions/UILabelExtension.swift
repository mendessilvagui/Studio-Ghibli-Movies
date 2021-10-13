//
//  UILabelExtension.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 13/10/21.
//

import UIKit

extension UILabel {

    func addShadowToLabel(color: CGColor, radius: CGFloat, offset: CGSize, opacity: Float) {
        self.layer.shadowColor = color
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
    }
}
