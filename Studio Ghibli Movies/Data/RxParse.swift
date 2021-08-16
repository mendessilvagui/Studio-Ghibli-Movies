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

	static func saveObject<T>(object: T) -> Single<T> where T: PFObject {
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

	static func deleteObject<T>(object:T) -> Completable where T: PFObject {
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

	static func getObject<T>(_ query: PFQuery<PFObject>) -> Single<T?> where T: PFObject {
		Single.create { observer -> Disposable in
			let disposable = Disposables.create {}
			query.getFirstObjectInBackground() { (fetchedObject: PFObject?, error: Error?) in
				guard !disposable.isDisposed else { return }
				if fetchedObject == nil {
					observer(.success(nil))
				} else if let fetchedObject = fetchedObject as? T {
					observer(.success(fetchedObject))
				} else {
					observer(.failure(ErrorType.generic))
				}
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
                    observer(.failure(ErrorType.generic))
                }
            }
            return disposable
        }
    }
}