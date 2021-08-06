//
//  DataBaseHandler.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import Foundation
import Parse
import RxSwift

struct DataBase {

    private var api = APIHandler.shared

    func save(object: PFObject) -> Single<PFObject> {
        let single: Single<PFObject> = Single.create { observer in
            let disposable = Disposables.create {}
            object.saveInBackground { (succeeded, error) in
                if disposable.isDisposed { return }
                if succeeded {
                    observer(.success(object))
                } else if let error = error {
                    observer(.failure(error))
                }
            }
            return disposable
        }
        return single
    }

    func save(object: PFObject, completion: @escaping (PFObject?) -> Void) {
        object.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                completion(object)
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    func delete(object: PFObject) {
        object.deleteInBackground() { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    func loadMovies(fetchComplete: @escaping (_ movies: [Movie]?) -> Void) {
        if let query = Movie.query() {
            query.order(byAscending: "releaseDate")
            query.findObjectsInBackground { objects , error in
                if objects?.count == 0 {
                    api.fetchMovie { movies in
                        fetchComplete(movies)
                    }
                } else if error == nil && objects != nil {
                    fetchComplete(objects as? [Movie])
                }
            }
        }
    }

    func loadDetails(selectedMovie: PFObject, fetchComplete: @escaping (_ details: Details?) -> Void) {
        if let query = Details.query() {
            query.whereKey("parentMovie", equalTo: selectedMovie)
            query.getFirstObjectInBackground { object, error in
                if error == nil && object != nil {
                    fetchComplete(object as? Details)
                } else {
                    fetchComplete(nil)
                }
            }
        }
    }
}

