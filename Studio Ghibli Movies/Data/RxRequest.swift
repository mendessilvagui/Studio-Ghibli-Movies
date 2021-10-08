//
//  RxRequest.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.

import Foundation
import Parse
import RxSwift
import RxCocoa

//MARK: - Fetch data from API and save to database

class RxRequest {

    final class func fetchMovies() -> Single<[Movie]> {
        Single.create { single in

			let url =  URL(string: L10n.url)!

			let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?)  in

                if let error = error {
                    single(.failure(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
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

extension RxRequest {

    static func get(url: String, parameters: [String: String]) -> Single<Data> {
        guard let url = URL(string: url + buildQueryString(dictionary: parameters)) else {
            return Single.error(ErrorType.generic)
        }
        var request = URLRequest(url: url)
        let headers: [String: String] = [
            "X-Parse-Application-Id": L10n.applicationId,
            "X-Parse-Client-Key": L10n.clientKey,
            "X-Parse-Revocable-Session": "1"
        ]
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.allHTTPHeaderFields = headers
        var task: URLSessionDataTask!
        var session: URLSession!
        return Single.create { observer -> Disposable in
            let disposable = Disposables.create {}
            let delegateQueue = OperationQueue()
            delegateQueue.qualityOfService = .userInitiated
            session = URLSession(configuration: .default, delegate: nil, delegateQueue: delegateQueue)
            task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                DispatchQueue.main.async {
                    guard !disposable.isDisposed else { return }
                    if let error = error {
                        observer(.failure(error))
                        return
                    } else if let data = data {
                        observer(.success(data))
                        return
                    }
                    observer(.failure(ErrorType.generic))
                }
            }
            task.resume()
            return disposable
        }.do(onDispose: {
            task.cancel()
            session.finishTasksAndInvalidate()
        })
    }

    static func getJSON(url: String, parameters: [String: String]) -> Single<[String: Any]> {
        return get(url: url, parameters: parameters).flatMap { (data: Data) -> Single<[String: Any]> in
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                // TODO: create malformed JSON error
                return Single.error(ErrorType.generic)
            }
            return Single.just(json)
        }
    }

    // MARK: Private methods

    // Reference: https://stackoverflow.com/a/25225010/1137914
    private static func buildQueryString(dictionary dict: [String: String]) -> String {
        var urlVars: [String] = []
        for (k, value) in dict {
            let value = value as NSString
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                urlVars.append(k + "=" + encodedValue)
            }
        }
        return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
    }
}
