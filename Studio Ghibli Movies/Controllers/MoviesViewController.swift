//
//  ViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 15/05/21.

import UIKit
import Parse

class MoviesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var api = APIHandler()
    var database = DataBase()
    var movies = [PFObject]()
    var filteredMovies = [PFObject]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBar")
        navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.backgroundColor = UIColor(named: "totoro")
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        api.fetchMovie {
            self.database.loadMovies { objects in
                self.movies = objects
                self.tableView.reloadData()
            }
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavoriteList), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
//    @objc func reloadFavoriteList() {
//        self.tableView.reloadData()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Movie", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
//MARK: - Set up Search Controlller
    
    func setUpSearchController() {
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.scopeButtonTitles = ["All", "Favorites"]
        searchController.searchBar.searchTextField.textColor = UIColor.white
    }
    
//MARK: - Filter favorite movies from all

    func isSearchBarEmpty() -> Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(searchText: String, scope: String) {
        
        filteredMovies = movies.filter({ (movie: PFObject) -> Bool in
            
            let childDetailIExists = movie["childDetail"] != nil
            
            if isSearchBarEmpty() {
                return childDetailIExists
            } else {
                if scope == "All" {
                    return (movie["title"] as! String).lowercased().contains(searchText.lowercased())
                } else {
                    return childDetailIExists && (movie["title"] as! String).lowercased().contains(searchText.lowercased())
                }
            }
        })
        tableView.reloadData()
    }
}

//MARK: - SearchBar Results and Delegate Methods

extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
        tableView.reloadData()
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource and Delegate Methods

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredMovies.count
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie: PFObject
        
        if isFiltering() {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        
        let title = movie["title"] as! String
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = title
        cell.backgroundColor = UIColor(named: "totoro")
        cell.textLabel?.textColor = UIColor.darkGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
        
            let movie: PFObject
            let destination = DetailsViewController()
            
            if isFiltering() {
                movie = filteredMovies[indexPath.row]
            } else {
                movie = movies[indexPath.row]
            }
        
            destination.selectedMovie = movie
            tableView.deselectRow(at: (tableView.indexPathForSelectedRow)!, animated: false)
            
            self.show(destination, sender: self)
        }
        self.searchController.searchBar.endEditing(true)
    }
}



