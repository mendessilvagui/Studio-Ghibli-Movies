//
//  DataBaseHandler.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import UIKit
import Parse

struct DataBase {
    
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
        let query = PFQuery(className: "Movie")
        query.order(byAscending: "release_date")
        query.findObjectsInBackground { objects , error in
            if error == nil {
                fetchComplete(objects as? [Movie])
            }
        }
    }
    
    func loadDetails(selectedMovie: PFObject, fetchComplete: @escaping (_ detail: Detail?) -> Void) {
        let query = PFQuery(className:"Detail")
        query.whereKey("parentMovie", equalTo: selectedMovie)
        query.getFirstObjectInBackground { object, error in
            if error == nil && object != nil {
                fetchComplete(object as? Detail)
            } else {
                fetchComplete(nil)
            }
        }
    }
}

