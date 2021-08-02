//
//  APIHandler.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import Foundation
import Parse

//MARK: - Fetch data from API and save to database

class APIHandler {

    static let shared = APIHandler()

    public var delegate: ReloadList?

    func fetchMovie(completion: @escaping (_ movies: [Movie]?) -> Void) {

        var req = URLRequest(url: URL(string: "https://ghibliapi.herokuapp.com/films")!)
        req.httpMethod = "GET"
        let session = URLSession.shared

        let task = session.dataTask(with: req, completionHandler: { data, response, error -> Void in

            do {
                if let data = data {
                    let models = try JSONDecoder().decode([MovieData].self, from: data)

                    let movies = models.map { movieData in
                        movieData.mapToPFMovie()
                    }
                    PFObject.saveAll(inBackground: movies) { isSaved, error in
                        if error == nil {
                            completion(movies)
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}

