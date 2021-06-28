//
//  DataBaseHandler.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import UIKit
import Parse

struct DataBase {

    func save(object: PFObject) {
        object.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
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
    
    func loadMovies(completion: @escaping ([PFObject]) -> Void) {
        let query = PFQuery(className: "Movie")
        query.order(byAscending: "release_date")
        query.findObjectsInBackground { objects , error in
            if error == nil {
                completion(objects!)
            }
        }
    }
    
    func loadDetails(selectedMovie: PFObject, completion: @escaping (PFObject?) -> Void) {
        let query = PFQuery(className:"Detail")
        query.whereKey("parentMovie", equalTo: selectedMovie)
        query.getFirstObjectInBackground { object, error in
            if error == nil && object != nil {
                completion(object!)
            } else {
                completion(nil)
            }
        }
    }
    
    func updateMovie(selectedMovie: PFObject, completion: @escaping (PFObject?) -> Void) {
        let query = PFQuery(className: "Movie")
        query.whereKey("objectId", equalTo: selectedMovie.objectId!)
        query.getFirstObjectInBackground { object, error in
            if error == nil && object != nil {
                completion(object)
            } else {
                completion(nil)
            }
        }
    }
}

