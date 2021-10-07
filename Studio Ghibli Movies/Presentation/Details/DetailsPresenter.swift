//
//  DetailsPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Dielson Sales on 19/07/21.
//

import Foundation
import Parse
import RxSwift

class DetailsPresenter {

    private weak var view: DetailsView?
    private let disposeBag = DisposeBag()
    private var selectedMovie = Movie()
    private var details = Details()
    private var user = User()

    init(selectedMovie: Movie) {
        self.selectedMovie = selectedMovie
    }

    func setView(view: DetailsView) {
        self.view = view
    }

    // MARK: - Presenter methods

    func start() {
        view?.showMovieData(selectedMovie)
    }

    func loadMovieDetails() {
        DataBase.loadDetails(selectedMovie: selectedMovie)
            .subscribe(onSuccess: { (detailsReturned: Details?) in
                if let detailsReturned = detailsReturned {
                    self.details = detailsReturned
                }
                self.view?.updateDetails(details: self.details)
            })
            .disposed(by: disposeBag)
    }

    func favorite(withComment comment: String) {
        self.details.selected = true
        self.details.comment = comment
        self.details.parentMovie = selectedMovie
        self.details.user = User.current()

		RxParse.saveObject(details)
            .subscribe(onSuccess: { _ in
                self.selectedMovie.childDetails = self.details
                self.selectedMovie.saveInBackground() {(succeeded, error)  in
                    if (succeeded) {
                        self.view?.updateComment(comment)
                    } else if let error = error {
                        print(error)
                    }
                }
                self.view?.reloadFavoriteMoviesTableView()
            })
            .disposed(by: disposeBag)
    }

    func unfavorite() {
		RxParse.deleteObject(details)
            .subscribe(onCompleted: {
                self.view?.reloadFavoriteMoviesTableView()
				self.selectedMovie.remove(forKey: L10n.childDetails)
                self.selectedMovie.saveInBackground() {(succeeded, error)  in
                    if (succeeded) {
                        // Detail successfully deleted
                    } else if let error = error {
                        print(error)
                    }
                }
                self.view?.reloadFavoriteMoviesTableView()
            })
            .disposed(by: disposeBag)
    }
}
