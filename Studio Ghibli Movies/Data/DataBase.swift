//
//  DataBase.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import Foundation
import Parse
import RxSwift

struct DataBase {

    static func loadMovies() -> Single<[Movie]> {
        guard let query = Movie.query()?
                .addAscendingOrder("releaseDate") else {
            return Single.error(ErrorType.generic)
        }
        return RxParse.findObjects(query).flatMap { (movies: [Movie]) in
            if movies.count == 0 {
                return RxRequest.fetchMovies()
            } else {
                return Single.just(movies)
            }
        }
    }

	static func loadDetails(selectedMovie: PFObject) -> Single<Details?> {
		guard let query = Details.query()?
				.whereKey("parentMovie", equalTo: selectedMovie) else {
			return Single.error(ErrorType.generic)
		}
		return RxParse.getObject(query).flatMap { (details: Details?) in
			return Single.just(details)
		}
	}
}
