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

//    let firstRun = UserDefaults.standard.bool(forKey: "firstRun") as Bool

    func fetchMovie() {

        var req = URLRequest(url: URL(string: "https://ghibliapi.herokuapp.com/films")!)
        req.httpMethod = "GET"
        let session = URLSession.shared

        let task = session.dataTask(with: req, completionHandler: { data, response, error -> Void in

            do {
                let model = try JSONDecoder().decode([MovieData].self, from: data!)
                /*
                if !self.firstRun {
                    model.forEach { $0.store() }
                    UserDefaults.standard.set(true, forKey: "firstRun")
                }
                */
                model.forEach { $0.store() }
                self.delegate?.reloadList()
                //completion()

            } catch {
                print(error.localizedDescription)
                //completion()
            }
        })
        task.resume()
    }
}

