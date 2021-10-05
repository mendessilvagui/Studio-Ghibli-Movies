//
//  DataBase.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import Foundation
import Parse
import RxSwift

struct DataBase {

    static func loadAllMovies() -> Single<[Movie]> {
        guard let query = Movie.query()?
				.addAscendingOrder(L10n.releaseDate) else {
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

    static func loadFavoriteMovies() -> Single<[Movie]> {
        guard let currentUser = User.current(), let detailsQuery = Details.query()?
                .whereKey("user", equalTo: currentUser) else {
            return Single.error(ErrorType.generic)
        }

        guard let query = Movie.query()?
                .whereKey("childDetails", matchesQuery: detailsQuery)
                .addAscendingOrder(L10n.releaseDate) else {
            return Single.error(ErrorType.generic)
        }
        
        return RxParse.findObjects(query).flatMap { (movies: [Movie]) in
            return Single.just(movies)
        }
    }

    static func loadDetails(selectedMovie: PFObject) -> Single<Details?> {
        guard let currentUser = User.current(), let query = Details.query()?
                .whereKey("user", equalTo: currentUser)
				.whereKey(L10n.parentMovie, equalTo: selectedMovie) else {
			return Single.error(ErrorType.generic)
		}

        return RxParse.getObject(query).flatMap { (details: Details?) in
			return Single.just(details)
		}
	}
}

