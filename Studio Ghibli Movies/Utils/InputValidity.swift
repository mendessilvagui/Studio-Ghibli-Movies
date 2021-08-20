//
//  InputValidity.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 20/08/21.
//

import Foundation

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
