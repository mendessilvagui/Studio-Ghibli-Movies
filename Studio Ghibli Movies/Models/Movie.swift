//
//  Movie.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 27/07/21.
//

import Foundation
import Parse

class Movie: PFObject, PFSubclassing {

    public static func parseClassName() -> String {
		return L10n.movie
    }

    @NSManaged var movieID: String
    @NSManaged var title: String
    @NSManaged var originalTitle: String
    @NSManaged var originalTitleRomanised: String
    @NSManaged var moreInfo: String
    @NSManaged var director: String
    @NSManaged var producer: String
    @NSManaged var releaseDate: String
    @NSManaged var runningTime: String
    @NSManaged var rtScore: String
    @NSManaged var childDetails: Details?
}
