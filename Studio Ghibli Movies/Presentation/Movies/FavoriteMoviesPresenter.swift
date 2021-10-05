//
//  FavoriteMoviesPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 05/10/21.
//

import Foundation
import Parse
import RxSwift

class FavoriteMoviesPresenter {

    private weak var view: MoviesView?
    private let disposeBag = DisposeBag()
    var favoritedMovies = [Movie]()

    func setView(view: MoviesView) {
        self.view = view
    }

    //MARK: - Presenter methods

    func loadFavoriteMoviesList() {
        DataBase.loadFavoriteMovies()
            .subscribe(onSuccess: { (movies: [Movie]) in
                self.favoritedMovies = movies
                self.view?.reloadTableView()
            })
            .disposed(by: disposeBag)
    }
}

