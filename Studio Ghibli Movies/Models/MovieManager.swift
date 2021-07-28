//
//  FilmManager.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/05/21.
//

import Foundation

protocol MovieManagerDelegate {
    func didUpdateList(movies: [MovieData])
}


class MovieManager {

    var delegate: MovieManagerDelegate?

    var movies = [MovieData]()

    func fetchMovie(completed: @escaping () -> ()) {

        let url = URL(string: "https://ghibliapi.herokuapp.com/films/")

        let task = URLSession.shared.dataTask(with: url!) { [self] (data, response, error) in

                if error == nil {
                    do {
                        self.movies =  try JSONDecoder().decode([MovieData].self, from: data!)
                        delegate?.didUpdateList(movies: movies)

                        DispatchQueue.main.async{
                            completed()
                        }

                    } catch {
                        print("JSON error")
                    }
                }
            }
            task.resume()
    }
}



