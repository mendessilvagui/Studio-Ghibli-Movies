//
//  Validation.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 04/10/21.
//

import Foundation

enum InputValidity: Equatable {
    case `default`
    case valid
    case invalid(error: FormError)

    static func == (lhs: InputValidity, rhs: InputValidity) -> Bool {
        switch (lhs, rhs) {
        case (.default, .default):
            return true
        case (.valid, .valid):
            return true
        case (.invalid(error: let lhsError), .invalid(error: let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

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

class FullNameCheck: RegexCheck {
    convenience init() {
        self.init(regex: #"^[a-zA-Z-]+ ?.* [a-zA-Z-]+$"#, error: FormError.name)
    }
}

class EmailCheck: RegexCheck {
    convenience init() {
        self.init(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", error: FormError.email)
    }
}

class PasswordCheck: RegexCheck {
    convenience init() {
        self.init(regex: #"(?=.{8,})"# + #"(?=.*[A-Z])"# + #"(?=.*[a-z])"# + #"(?=.*\d)"#, error: FormError.password)
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
