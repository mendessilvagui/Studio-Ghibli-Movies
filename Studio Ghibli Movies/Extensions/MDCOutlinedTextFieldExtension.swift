//
//  MDCOutlinedTextFieldExtension.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 27/09/21.
//

import Foundation
import MaterialComponents

extension MDCOutlinedTextField {

    func setTextFieldValidity(_ validity: InputValidity) {
        switch validity {
        case .default:
            setTextFieldColors(color: ColorCompat.defaultFieldColor)
        case .valid:
            setTextFieldColors(color: ColorCompat.validFieldColor)
        case .invalid:
            setTextFieldColors(color: ColorCompat.invalidFieldColor)
        }
    }

    func styleTextField(fieldColor: UIColor?, textColor: UIColor?) {
		guard let fieldColor = fieldColor, let textColor = textColor else { return }
        self.label.font = UIFont.systemFont(ofSize: 10)
        self.setTextFieldColors(color: fieldColor)
        self.setTextColor(textColor, for: .normal)
        self.setTextColor(textColor, for: .editing)
    }

    func styleLoginTextFiels(labelText: String, iconName: String) {
        self.label.text = labelText
        self.styleTextField(fieldColor: UIColor(named: L10n.totoroGray), textColor: UIColor(named: L10n.totoroGray))

        let icon = UIImage(systemName: iconName)
        self.leftView = UIImageView(image: icon)
        self.leftView?.tintColor = UIColor(named: L10n.totoroGray)
        self.leftViewMode = .unlessEditing
    }

    func togglePasswordVisibility(for button: UIButton) {
        isSecureTextEntry = !isSecureTextEntry

        if isSecureTextEntry {
            button.setBackgroundImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        } else {
            button.setBackgroundImage(UIImage(systemName: "eye.fill"), for: .normal)
        }

        if let existingText = text, isSecureTextEntry {
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }

    func addButtonToRightView(button: UIButton, selector: Selector, color: UIColor?, target: UIViewController) {
        button.frame = CGRect(x: 0, y: 0, width: CGFloat(30), height: CGFloat(20))
        button.setBackgroundImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.tintColor = color
        self.rightView = button
        self.rightViewMode = .whileEditing
        button.addTarget(target, action: selector, for: .touchUpInside)
    }

    private func setTextFieldColors(color: UIColor) {
        self.setOutlineColor(color, for: .normal)
        self.setOutlineColor(color, for: .editing)
        self.setFloatingLabelColor(color, for: .normal)
        self.setFloatingLabelColor(color, for: .editing)
        self.setNormalLabelColor(color, for: .normal)
        self.setNormalLabelColor(color, for: .editing)
        self.setLeadingAssistiveLabelColor(color, for: .normal)
        self.setLeadingAssistiveLabelColor(color, for: .editing)
    }
}
