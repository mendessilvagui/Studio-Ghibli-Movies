//
//  RxRequest.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import Foundation
import Parse
import RxSwift
import RxCocoa
import Alamofire

//MARK: - Fetch data from API and save to database

class RxRequest {

//    final class func fetchMovie(completion: @escaping (_ movies: [Movie]?) -> Void) {
//
//        let url = "https://ghibliapi.herokuapp.com/films"
//        let request = AF.request(url)
//
//        request.responseDecodable(of: [MovieData].self) { response in
//
//            guard let response = response.value else { return }
//
//            let movies = response.map { movieData in
//                movieData.mapToPFMovie()
//            }
//            PFObject.saveAll(inBackground: movies) { isSaved, error in
//                if error == nil {
//                    completion(movies)
//                }
//            }
//        }
//    }

    final class func fetchMovies() -> Single<[Movie]> {
        Single.create { single in

            let url =  URL(string: "https://ghibliapi.herokuapp.com/films")!

			let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?)  in

                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                    single(.failure(ErrorType.invalidResponse(response)))
                    return
                }

                guard let data = data else {
                    single(.failure(ErrorType.emptyData))
                    return
                }

                do {
                    let models = try JSONDecoder().decode([MovieData].self, from: data)

                    let movies = models.map { movieData in
                        movieData.mapToPFMovie()
                    }
                    PFObject.saveAll(inBackground: movies) { _ , error in
                        if error == nil {
                            single(.success(movies))
                        }
                    }
                } catch let jsonError {
                    single(.failure(ErrorType.invalidJSON(jsonError)))
                }
            }
            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}
