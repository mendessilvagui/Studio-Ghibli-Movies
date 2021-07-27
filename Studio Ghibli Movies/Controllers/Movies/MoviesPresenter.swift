//
//  MoviesPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 21/07/21.
//

import Foundation
import Parse

class MoviesPresenter {
    
    private weak var view: MoviesView?
    
    private var api = APIHandler()
    private var database = DataBase()
    
    var movies = [PFObject]()
    var filteredMovies = [PFObject]()
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var currentScope = "All"
    var currentText = ""

    func setView(view: MoviesView) {
        self.view = view
    }
    
    //MARK: - Presenter methods
    
    func loadMoviesList() {
        api.fetchMovie {
            self.database.loadMovies { objects in
                self.movies = objects
                self.view?.reloadTableView()
            }
        }
    }
    
    private func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(searchText: String, scope: String) {
        
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
        self.view?.reloadTableView()
    }
}
