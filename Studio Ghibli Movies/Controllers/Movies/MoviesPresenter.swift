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

    private var api = APIHandler.shared
    private var database = DataBase()

    var movies = [Movie]()
    var filteredMovies = [Movie]()

    var searchController = UISearchController(searchResultsController: nil)

    var currentScope = "All"
    var currentText = ""

    func setView(view: MoviesView) {
        self.view = view
    }

    //MARK: - Presenter methods

    func loadMoviesList() {
        api.fetchMovie {
            self.database.loadMovies { movies in
                self.movies = movies!
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

        filteredMovies = movies.filter({ (movie: Movie) -> Bool in

            let childDetailIExists = movie.childDetails != nil

            if isSearchBarEmpty() {
                return childDetailIExists
            } else {
                if scope == "All" {
                    return (movie.title).lowercased().contains(searchText.lowercased())
                } else {
                    return childDetailIExists && (movie.title).lowercased().contains(searchText.lowercased())
                }
            }
        })
        self.view?.reloadTableView()
    }
}
