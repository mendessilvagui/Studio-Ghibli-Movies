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
                self.reloadDataSavingSelections()
            }
        }
    }

    var pickedMovie: MovieData?

    override func viewDidLoad() {

        movieManager.fetchMovie{ movieArray in
            self.movieList = movieArray
        }

        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

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

    //MARK - TableView Delegate

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let movie = movieList[indexPath.row]
        pickedMovie = movie

        print(indexPath.row)

        self.performSegue(withIdentifier: "goToDetails", sender: self)
    }

    //MARK - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            let indexPath = tableView.indexPathForSelectedRow
            let index = indexPath?.row
            let detailsVC = segue.destination as! DetailsViewController

            detailsVC.index = index
        }
    }

    func reloadDataSavingSelections() {
        let indexPaths = tableView.indexPathsForSelectedRows

        tableView.reloadData()

        for path in indexPaths ?? [] {
            tableView.selectRow(at: path, animated: false, scrollPosition: .none)
        }
    }
}
