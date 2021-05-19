//
//  APIHandler.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 18/05/21.


import Foundation

//MARK: - Fetch data from API and save to database

class APIHandler {
    
    static let shared = APIHandler()
    
    func fetchMovie(completion: @escaping (() -> Void)) {
    
        var req = URLRequest(url: URL(string: "https://ghibliapi.herokuapp.com/films")!)
        req.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: req, completionHandler: { data, response, error -> Void in
           
            do {
                let model = try JSONDecoder().decode([MovieServerModel].self, from: data!)
                model.forEach { $0.store() }
                completion()
            } catch {
                print(error.localizedDescription)
                completion()
            }
        })
        
        task.resume()
    }
}
