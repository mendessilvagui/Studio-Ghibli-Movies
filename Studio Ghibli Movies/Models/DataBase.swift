//
//  DataBaseHandler.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import Foundation
import Parse
import RxSwift

struct DataBase {

    static func save<T>(object: T) -> Single<T> where T: PFObject {
        Single.create { observer -> Disposable in
            let disposable = Disposables.create {}
            object.saveInBackground { (succeeded: Bool, error: Error?) in
                guard !disposable.isDisposed else { return }
                if let error = error {
                    observer(.failure(error))
                    return
                }
                observer(.success(object))
            }
            return disposable
        }
    }

//    static func save(object: PFObject, completion: @escaping (PFObject?) -> Void) {
//        object.saveInBackground { (succeeded: Bool, error: Error?)  in
//            if (succeeded) {
//                completion(object)
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
//    }

    static func delete<T>(object:T) -> Completable where T: PFObject {
        Completable.create { observer -> Disposable in
            let disposable = Disposables.create {}
            object.deleteInBackground { (succeeded: Bool, error: Error?) in
                guard !disposable.isDisposed else { return }
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            }
            return disposable
        }
    }

//    static func delete(object: PFObject) {
//        object.deleteInBackground() { (succeeded: Bool, error: Error?)  in
//            if (succeeded) {
//                // The object has been saved.
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
//    }

    static func loadMovies() -> Single<[Movie]?> {
        Single.create { observer -> Disposable in
            let disposable = Disposables.create {}

            if let query = Movie.query()?
                .addAscendingOrder("releaseDate") {
                query.findObjectsInBackground { (fetchedObjects: [PFObject]?, error: Error?) in
                    guard !disposable.isDisposed else { return }
//                    if let error = error {
//                        observer(.failure(error))
//                        return
//                    } else if let fetchedObjects = fetchedObjects as? [Movie] {
//                        if fetchedObjects.count == 0 {
//                            APIHandler.fetchMovie { _ in
//                                observer(.success(fetchedObjects))
//                            }
//                        }
//                        observer(.success(fetchedObjects))
//                    }
                    if fetchedObjects?.count == 0 {
                        APIHandler.fetchMovie { movies in
                            observer(.success(movies))
                        }
//                        APIHandler.fetchMovie()
//                            .observe(on: MainScheduler.instance)
//                            .subscribe(onSuccess: { movies in
//                                observer(.success(movies as? [Movie]))
//                            })
//                            .disposed(by: DisposeBag())

                    } else if error == nil && fetchedObjects != nil {
                        observer(.success(fetchedObjects as? [Movie]))
                    }
                }
            }
            return disposable
        }
    }

//    static func loadMovies(fetchComplete: @escaping (_ movies: [Movie]?) -> Void) {
//        if let query = Movie.query()?
//            .addAscendingOrder("releaseDate") {
//            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
//                if objects?.count == 0 {
//                    APIHandler.fetchMovie { movies in
//                        fetchComplete(movies)
//                    }
//                } else if error == nil && objects != nil {
//                    fetchComplete(objects as? [Movie])
//                }
//            }
//        }
//    }

    static func loadDetails(selectedMovie: PFObject) -> Single<Details?> {
        Single.create { observer -> Disposable in
            let disposable = Disposables.create {}

            if let query = Details.query()?
                .whereKey("parentMovie", equalTo: selectedMovie) {
                query.getFirstObjectInBackground { (fetchedObject: PFObject?, error: Error?) in
                    guard !disposable.isDisposed else { return }
//                    if let error = error {
//                        observer(.failure(error))
//                        return
//                    } else if let fetchedObject = fetchedObject as? Details {
//                        observer(.success(fetchedObject))
//                    }
//                    observer(.success(nil))
                    if error == nil && fetchedObject != nil {
                        observer(.success(fetchedObject as? Details))
                    } else {
                        observer(.success(nil))
                    }
                }
            }
            return disposable
        }
    }

//    static func loadDetails(selectedMovie: PFObject, fetchComplete: @escaping (_ details: Details?) -> Void) {
//        if let query = Details.query()?
//            .whereKey("parentMovie", equalTo: selectedMovie) {
//            query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
//                if error == nil && object != nil {
//                    fetchComplete(object as? Details)
//                } else {
//                    fetchComplete(nil)
//                }
//            }
//        }
//    }
}

