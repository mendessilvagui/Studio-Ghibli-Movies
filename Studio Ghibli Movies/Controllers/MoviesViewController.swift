//
//  ViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 15/05/21.
//

//
//  ViewController.swift
//  API Test
//
//  Created by Guilherme Mendes on 15/05/21.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [MovieData]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMovie {
            self.tableView.reloadData()
        }

        tableView.delegate = self
        tableView.dataSource = self
    }
    
// MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = movies[indexPath.row].title
        return cell
    }
    
// MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let destination = segue.destination as? DetailsViewController {
                destination.movie = movies[(tableView.indexPathForSelectedRow?.row)!]
            }
        }
    }
    
// MARK: - API call and handling
    
    func fetchMovie(completed: @escaping () -> ()) {

        let url = URL(string: "https://ghibliapi.herokuapp.com/films/")

            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in

                if error == nil {
                    do {
                        self.movies =  try JSONDecoder().decode([MovieData].self, from: data!)

                        DispatchQueue.main.async{
                            completed()
                        }

                    } catch {
                        print("JSON error")
                    }
                }
            }
        task.resume()
    }
}
