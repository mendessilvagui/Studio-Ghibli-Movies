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
        return "Movie"
    }

    @NSManaged var movie_id: String
    @NSManaged var title: String
    @NSManaged var original_title: String
    @NSManaged var original_title_romanised: String
    @NSManaged var more_info: String
    @NSManaged var director: String
    @NSManaged var producer: String
    @NSManaged var release_date: String
    @NSManaged var running_time: String
    @NSManaged var rt_score: String
    @NSManaged var childDetail: Detail?
}
