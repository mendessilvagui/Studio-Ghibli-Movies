//
//  ViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 15/05/21.

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var api = APIHandler()
    var database = DataBaseHandler.shared
        
    var movies: [Movie]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        api.fetchMovie {
            self.movies = self.database.fetch(Movie.self)
        }

        tableView.delegate = self
        tableView.dataSource = self
    }

// MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = movies?[indexPath.row].title
        cell.backgroundColor = UIColor(named: "totoro")
        cell.textLabel?.textColor = UIColor.darkGray
        return cell
    }

// MARK: - TableView Delegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "showDetails", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let destination = segue.destination as? DetailsViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destination?.selectedMovie = movies?[indexPath.row]
                tableView.deselectRow(at: (tableView.indexPathForSelectedRow)!, animated: false)
            }
        }
    }
}

