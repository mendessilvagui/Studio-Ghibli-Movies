//
//  ErrorType.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/08/21.
//

import Foundation

enum FormError: Error {
    case name
    case email
    case password
    case passwordConfirmation
    case generic
    case wrongOldPassword
    case userNotLogged
    case other

    var localizedDescription: String {
        switch self {
        case .name:
            return L10n.registerErrorNameFull
        case .email:
            return L10n.registerErrorInvalidEmail
        case .password:
            return L10n.registerErrorInvalidPassword
        case .passwordConfirmation:
            return L10n.registerErrorDifferentPasswords
        case .generic:
            return L10n.genericError
        case .wrongOldPassword:
            return L10n.resetpasswordMessageWrongCurrentPassword
        case .userNotLogged:
            return "Please login to change your password"
        default:
            return L10n.genericError
        }
    }
}

enum ErrorType: Error {

	case invalidResponse(URLResponse?)
	case emptyData
	case invalidJSON(Error)
	case generic

	var localizedDescription: String {
		switch self {
		case .invalidResponse:
			return L10n.invalidResponse
		case .emptyData:
			return L10n.emptyData
		case .invalidJSON:
			return L10n.invalidJson
		case .generic:
			return L10n.genericError
		}
	}
}
