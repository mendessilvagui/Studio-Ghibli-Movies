//
//  FilmManager.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/05/21.
//

import Foundation

class MovieManager {

    let url = "https://ghibliapi.herokuapp.com/films/"

    func fetchMovie(from url: String) {
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("Couldn't fetch data.")
                return
            }
            
            var result: [MovieData]?
            
            do {
                result = try JSONDecoder().decode([MovieData].self, from: data)
            } catch {
                print("Failed to convert data \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            print(json[0].description)
            print(json[0].director)
            print(json[0].original_title)
        })
        
        task.resume()
    }
}

