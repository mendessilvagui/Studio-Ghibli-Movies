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
    
    func setView(view: MoviesView) {
        self.view = view
    }

    //MARK: - Presenter methods

    func loadMoviesList() {
        if movies.count == 0 {
            DataBase.loadAllMovies()
                .subscribe(onSuccess: { (movies: [Movie]) in
                    self.movies = movies
                    self.view?.reloadTableView()
                })
                .disposed(by: disposeBag)
        } else {
            self.view?.reloadTableView()
        }
    }
}
