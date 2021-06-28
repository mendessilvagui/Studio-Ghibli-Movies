//
//  MoviesData.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/05/21.

import Foundation
import Parse

class Movie: Codable {
    
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
        
        let database = DataBase()
		let movie = PFObject(className:"Movie")

		movie["movie_id"] = id
		movie["title"] = title
		movie["original_title"] = original_title
		movie["original_title_romanised"] = original_title_romanised
		movie["more_info"] = description
		movie["director"] = director
		movie["producer"] = producer
		movie["release_date"] = release_date
		movie["running_time"] = running_time
		movie["rt_score"] = rt_score
        database.save(object: movie)
    }
}
