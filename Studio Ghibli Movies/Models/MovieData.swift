//
//  MoviesData.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/05/21.
//

import Foundation

struct MovieData: Codable {
    
    let id: String
    let title : String
    let original_title : String
    let original_title_romanised: String
    let description : String
    let director : String
    let producer : String
    let release_date : String
    let running_time : String
    let rt_score : String
    
}
