//
//  APIHandler.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import Foundation
import Parse
import RxSwift
import RxCocoa
import Alamofire

//MARK: - Fetch data from API and save to database

class APIHandler {

//    enum Error: Swift.Error {
//        case invalidResponse(URLResponse?)
//        case emptyData
//        case invalidJSON(Swift.Error)
//        case network(Swift.Error)
//    }

    final class func fetchMovie(completion: @escaping (_ movies: [Movie]?) -> Void) {

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

//    final class func fetchMovie() -> Single<[MovieData]> {
//        Single.create { single in
//
//            let url =  URL(string: "https://ghibliapi.herokuapp.com/films")!
//
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error)  in
//
//                if let error = error {
//                    single(.failure(Error.network(error)))
//                    return
//                }
//                guard let httpResponse = response as? HTTPURLResponse,
//                    httpResponse.statusCode == 200 else {
//                    single(.failure(Error.invalidResponse(response)))
//                    return
//                }
//
//                guard let data = data else {
//                    single(.failure(Error.emptyData))
//                    return
//                }
//
//                do {
//                    let models = try JSONDecoder().decode([MovieData].self, from: data)
//
//                    let movies = models.map { movieData in
//                        movieData.mapToPFMovie()
//                    }
//                    PFObject.saveAll(inBackground: movies) { _ , error in
//                        if error == nil {
//                            single(.success(models))
//                        }
//                    }
//                } catch let error {
//                    single(.failure(Error.invalidJSON(error)))
//                }
//            }
//            task.resume()
//
//            return Disposables.create { task.cancel() }
//        }
//    }
}
