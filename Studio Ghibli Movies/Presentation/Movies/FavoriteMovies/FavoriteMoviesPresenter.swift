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

    private weak var view: FavoriteMoviesView?
    private let disposeBag = DisposeBag()
    var favoritedMovies = [Movie]()

    func setView(view: FavoriteMoviesView) {
        self.view = view
    }

    //MARK: - Presenter methods

    func loadFavoriteMoviesList() {
        DataBase.loadFavoriteMovies()
            .subscribe(onSuccess: { (movies: [Movie]) in
                self.favoritedMovies = movies
                self.view?.reloadTableView()
                self.view?.checkIfListIsEmpty()
            })
            .disposed(by: disposeBag)
    }
}

