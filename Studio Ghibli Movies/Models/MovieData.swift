//
//  MoviesData.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/05/21.

import Foundation
import Parse

class MovieData: Codable {

    let id: String
    var title : String
    let original_title : String
    let original_title_romanised: String
    let description : String
    let director : String
    let producer : String
    let release_date : String
    let running_time : String
    let rt_score : String

// MARK: - Save new model to database

    func store() {

		let movie = Movie()

        movie.movieID = id
        movie.title = title
        movie.originalTitle = original_title
        movie.originalTitleRomanised = original_title_romanised
        movie.moreInfo = description
        movie.director = director
        movie.producer = producer
        movie.releaseDate = release_date
        movie.runningTime = running_time
        movie.rtScore = rt_score

        movie.saveInBackground() { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
}
