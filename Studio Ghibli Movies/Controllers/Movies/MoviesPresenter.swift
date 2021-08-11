//
//  MoviesPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 21/07/21.
//

import Foundation
import Parse
import RxSwift

class MoviesPresenter {

    private weak var view: MoviesView?

    private let disposeBag = DisposeBag()

    var movies = [Movie]()
    var filteredMovies = [Movie]()

    var searchController = UISearchController(searchResultsController: nil)

    var currentScope = "All"
    var currentText = ""

    func setView(view: MoviesView) {
        self.view = view
    }

    //MARK: - Presenter methods

//    func loadMoviesList() {
//        if movies.count == 0 {
//            DataBase.loadMovies { movies in
//                self.movies = movies!
//                self.view?.reloadTableView()
//            }
//        } else {
//            self.view?.reloadTableView()
//        }
//    }

    func loadMoviesList() {
        if movies.count == 0 {
            DataBase.loadMovies()
                .subscribe(onSuccess: { (movies: [Movie]?) in
                    guard let movies = movies else { return }
                    self.movies = movies
                    self.view?.reloadTableView()
                })
                .disposed(by: disposeBag)
        } else {
            self.view?.reloadTableView()
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
