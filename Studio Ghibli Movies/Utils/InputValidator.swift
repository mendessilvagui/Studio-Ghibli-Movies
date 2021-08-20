//
//  InputValidator.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 20/08/21.
//

import Foundation

protocol ValidationCheck {
    func validate(input: String) -> InputValidity
}

class InputValidator {

    static func validateInput(rules: [ValidationCheck], input: String) -> InputValidity {
        if input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .default
        }
        var result: InputValidity = .valid
        for rule in rules {
            let validity = rule.validate(input: input)
            switch validity {
            case .invalid(error: let error):
                result = .invalid(error: error)
            default:
                continue
            }
        }
        return result
    }
}

class RegexCheck: ValidationCheck {
    let regex: String
    let error: FormError

    init(regex: String, error: FormError) {
        self.regex = regex
        self.error = error
    }

    func validate(input: String) -> InputValidity {
        let matching = input.range(of: regex, options: .regularExpression)
        if matching != nil {
            return .valid
        }
        return .invalid(error: error)
    }
}

class NumbersCheck: RegexCheck {
    convenience init() {
        self.init(regex: "^[\\d]*$", error: FormError.other)
    }
}

class EmailCheck: RegexCheck {
    convenience init() {
        // swiftlint:disable:next line_length
        self.init(regex: "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", error: FormError.email)
    }
}

class CustomCheck: ValidationCheck {
    let closure: (_: String) -> Bool
    let error: FormError

    init(closure: @escaping (_: String) -> Bool, error: FormError) {
        self.closure = closure
        self.error = error
    }

    func validate(input: String) -> InputValidity {
        if closure(input) {
            return .valid
        }
        return .invalid(error: error)
    }
}

class MinLengthCheck: CustomCheck {
    convenience init(minLength: Int) {
        self.init(
            closure: { (text: String) in text.count >= minLength },
            error: FormError.other
        )
    }
}

class MaxLengthCheck: CustomCheck {
    convenience init(maxLength: Int) {
        self.init(
            closure: { (text: String) in text.count <= maxLength },
            error: FormError.other
        )
    }
}

class FullNameCheck: CustomCheck {
    convenience init() {
        self.init(
            closure: { (text: String) in
                let array = text.split(separator: " ")
                return array.count >= 2
            },
            error: FormError.name
        )
    }
}

class PasswordCheck: CustomCheck {
    convenience init(minLength: Int) {
        self.init(
            closure: { (text: String) in text.count >= minLength },
            error: FormError.password
        )
    }
}

class PasswordConfirmationCheck: ValidationCheck {
    let password: String

    init(field: String) {
        self.password = field
    }

    func validate(input: String) -> InputValidity {
        if input == password {
            return .valid
        }
        return .invalid(error: FormError.passwordConfirmation)
    }
}
