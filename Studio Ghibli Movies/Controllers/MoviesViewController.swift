//
//  ViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 15/05/21.

import UIKit
import Parse

class MoviesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var api = APIHandler()
    private var database = DataBase()
    private var movies = [PFObject]()
    private var filteredMovies = [PFObject]()
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var currentScope = "All"
    private var currentText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBar")
        navigationController?.navigationBar.tintColor = UIColor.white
        
        setUpSearchController()
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self

        styleTableViewBackground()
        tableView.delegate = self
        tableView.dataSource = self
        registerTableViewCells()
        
        if movies.count != 0 {
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMoviesList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Movie", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    private func loadMoviesList() {
        api.fetchMovie {
            self.database.loadMovies { objects in
                self.movies = objects
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Filter favorite movies from all

extension MoviesViewController {

    private func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
    
    private func filterContentForSearchText(searchText: String, scope: String) {
        
        currentText = searchText
        currentScope = scope
        
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
    internal func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    internal func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

// MARK: - TableView DataSource and Delegate Methods

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func registerTableViewCells() {
        let customCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(customCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
        
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
        let subTitle = movie["original_title"] as! String
        let id = movie["movie_id"] as! String
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {
            
            cell.titleLabel.text = title
            cell.subTitleLabel.text = subTitle
            cell.cellImageView.image = UIImage(named: "poster-\(id)")
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
    
            let detailVC = DetailsViewController()
            detailVC.moviesVC = self
            detailVC.delegate = self
            
            let movie = isFiltering() ? filteredMovies[indexPath.row] : movies[indexPath.row]
        
            detailVC.selectedMovie = movie
            tableView.deselectRow(at: (tableView.indexPathForSelectedRow)!, animated: false)
            
            self.show(detailVC, sender: self)
        }
        self.searchController.searchBar.endEditing(true)
    }
}

//MARK: - Protocol to reload filtered movies list when coming back from DetailViewController

protocol ReloadList {
    func reloadList()
}

extension MoviesViewController: ReloadList {

    func reloadList() {
        filterContentForSearchText(searchText: currentText, scope: currentScope)
    }
}

//MARK: - Set up SearchController and TableView background

extension MoviesViewController {
    
    func setUpSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.scopeButtonTitles = ["All", "Favorites"]
        searchController.searchBar.searchTextField.textColor = UIColor.white
    }
    
    func styleTableViewBackground() {
        
        let image = UIImage(named: "TOTORO")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        
        let backView = UIView(frame: imageView.bounds)
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        imageView.addSubview(backView)
        
        tableView.backgroundView = imageView
        tableView.separatorStyle = .none
    }
}
