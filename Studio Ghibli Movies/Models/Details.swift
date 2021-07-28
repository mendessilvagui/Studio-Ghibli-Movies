//
//  Details.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 27/07/21.
//

import Foundation
import Parse

class Details: PFObject, PFSubclassing {

    public static func parseClassName() -> String {
        return "Details"
    }

    @NSManaged var selected: Bool
    @NSManaged var comment: String?
    @NSManaged var parentMovie: Movie
}
