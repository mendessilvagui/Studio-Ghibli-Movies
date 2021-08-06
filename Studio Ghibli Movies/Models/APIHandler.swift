//
//  APIHandler.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import Foundation
import Parse
import Alamofire

//MARK: - Fetch data from API and save to database

class APIHandler {

    static let shared = APIHandler()

    func fetchMovie(completion: @escaping (_ movies: [Movie]?) -> Void) {

        let url = "https://ghibliapi.herokuapp.com/films"
        let request = AF.request(url)

        request.responseDecodable(of: [MovieData].self) { response in
            
            guard let response = response.value else { return }

            let movies = response.map { movieData in
                movieData.mapToPFMovie()
            }
            PFObject.saveAll(inBackground: movies) { isSaved, error in
                if error == nil {
                    completion(movies)
                }
            }
        }
    }
}

