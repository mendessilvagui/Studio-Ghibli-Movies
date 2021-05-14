//
//  MoviesTableViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 13/05/21.
//

import UIKit

class MoviesTableViewController: UITableViewController {

    var movieManager = MovieManager()
    
    var movieList = [MovieData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var filteredList = [MovieData]()

    override func viewDidLoad() {
        
        movieManager.fetchMovie{ movieArray in
            self.movieList = movieArray
        }
        super.viewDidLoad()
        tableView.dataSource = self

    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  movieList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMoviesCell", for: indexPath)
        cell.textLabel?.text = self.movieList[indexPath.row].title
        return cell
    }
}



