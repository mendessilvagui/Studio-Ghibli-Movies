//
//  RxParse.swift
//  Studio Ghibli Movies
//
//  Created by Dielson Sales on 13/08/21.
//

import Foundation
import Parse
import RxSwift

class RxParse {

    static func fetchObject<T>(_ object: T) -> Single<T> where T: PFObject {
        Single.create { observer -> Disposable in
            let disposable = Disposables.create {}
            object.fetchInBackground { (_: PFObject?, error: Error?) in
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

    static func findObjects<T>(_ query: PFQuery<PFObject>) -> Single<[T]> where T: PFObject {
        Single.create { observer -> Disposable in
            let disposable = Disposables.create {}
            query.findObjectsInBackground { (fetchedObjects: [PFObject]?, error: Error?) in
                guard !disposable.isDisposed else { return }
                if let error = error {
                    observer(.failure(error))
                    return
                } else if let fetchedObjects = fetchedObjects as? [T] {
                    observer(.success(fetchedObjects))
                } else {
                    observer(.failure(APIHandler.Error.generic))
                }
            }
            return disposable
        }
    }

}
