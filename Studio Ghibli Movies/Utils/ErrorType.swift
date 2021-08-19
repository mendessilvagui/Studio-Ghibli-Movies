//
//  ErrorType.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/08/21.
//

import Foundation

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
			return L10n.generic
		}
	}
}
