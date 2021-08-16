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
			return "Error connecting to API"
		case .emptyData:
			return "Couldn't fetch data from API."
		case .invalidJSON:
			return "Couldn't get JSON data"
		case .generic:
			return "An error occurred. Please try again."
		}
	}
}
