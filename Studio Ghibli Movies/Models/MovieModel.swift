//
//  File.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 14/05/21.
//

class MovieModel {
    
    var title : String
    var original_title : String
    var original_title_romanised: String
    var description : String
    var director : String
    var producer : String
    var release_date : String
    var running_time : String
    var rt_score : String
    
    init(title : String, original_title : String, original_title_romanised: String, description : String, director : String, producer : String, release_date : String, running_time : String, rt_score : String) {
        self.title = title
        self.original_title = original_title
        self.original_title_romanised = original_title_romanised
        self.description = description
        self.director = director
        self.producer = producer
        self.release_date = release_date
        self.running_time = running_time
        self.rt_score = rt_score
    }
}
