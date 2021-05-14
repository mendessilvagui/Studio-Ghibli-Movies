//
//  FilmManager.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/05/21.
//

import Foundation

class MovieManager {

    let url = "https://ghibliapi.herokuapp.com/films/"

    func fetchMovie(completionHandler:@escaping ([MovieData]) -> Void) {
        
        var movieList = [MovieData]()
        
        if let urlToServer = URL.init(string: url) {
            
            let task = URLSession.shared.dataTask(with: urlToServer, completionHandler: { data, response, error in
            
                if error != nil || data == nil {
                    print("An error occured while fetching data from API")
                } else {
                    if let responseText = String.init(data: data!, encoding: .ascii) {
                        let jsonData = responseText.data(using: .utf8)!
                        movieList = try! JSONDecoder().decode([MovieData].self, from: jsonData)
            
                        completionHandler(movieList)
                    }
                }
            })
            
            task.resume()
        }
        
        completionHandler(movieList)
    }
}



