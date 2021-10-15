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

//    static func fetchAllUsersWithComments() -> Single<[User]> {
//
//        guard let detailsQuerry = Details.query()?
//                .whereKeyExists("comment") else {
//                    return Single.error(ErrorType.generic)
//                }
//
//        guard let query = User.query()
//                ?.whereKey(<#T##key: String##String#>, matchesQuery: <#T##PFQuery<PFObject>#>) else {
//            return Single.error(ErrorType.generic)
//        }
//
//        return RxParse.findObjects(query).flatMap { (users: [User]) in
//            return Single.just(users)
//        }
//    }

    static func fetchUser(_ user: User) -> Single<User> {
        return RxParse.fetchObject(user)
    }

    static func saveUser(_ user: User) -> Single<User> {
        return RxParse.saveObject(user)
    }

    static func getCurrentUser() -> User? {
        if let currentUser = User.current() {
            return currentUser
        }
        return nil
    }

    static func logoutCurrentUser() -> Completable {
        return RxParse.logOut()
            .andThen(updateParseInstallation())
    }

    static func changePassword(_ oldPassword: String, _ newPassword: String) -> Completable {
        guard let currentUser = getCurrentUser(),
              let username = currentUser.username else {
            return Completable.error(FormError.userNotLogged)
        }
        currentUser.password = newPassword
        return checkPassword(oldPassword).flatMap({ (oldPasswordMatch: Bool) -> Single<User> in
            if oldPasswordMatch {
                return saveUser(currentUser)
            } else {
                return Single.error(FormError.wrongOldPassword)
            }
        }).flatMapCompletable { (_: User) -> Completable in
            RxParse.logOut()
        }
        .andThen(RxParse.logIn(withUsername: username, password: newPassword))
        .asCompletable()
    }

    private static func checkPassword(_ password: String) -> Single<Bool> {
        guard let currentUser = getCurrentUser() else {
            return Single.just(false)
        }
        let url = "\(L10n.server)login"
        let params: [String: String] = [
            "username": currentUser.username ?? "",
            "password": password
        ]
        return RxRequest.getJSON(url: url, parameters: params).map { (result: [String: Any]) -> Bool in
            return result["objectId"] != nil
        }
    }

    private static func updateParseInstallation() -> Completable {
        if let parseInstallation = PFInstallation.current() {
            parseInstallation["user"] = NSNull()
            return RxParse.saveObject(parseInstallation).asCompletable()
        } else {
            return Completable.empty()
        }
    }
}

