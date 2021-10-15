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

    init(selectedMovie: Movie, user: User) {
        self.selectedMovie = selectedMovie
        self.user = user
    }

    func setView(view: DetailsView) {
        self.view = view
    }

    // MARK: - Public methods

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

    func favorite() {
        self.details.selected = true
        self.details.parentMovie = selectedMovie
        self.details.user = User.current()

        self.view?.showIndicator(L10n.saving)
		RxParse.saveObject(details)
            .subscribe(onSuccess: { _ in
                self.view?.hideIndicator()
                self.view?.updateFavButton()
                self.selectedMovie.childDetails = self.details

                let relation = self.user.relation(forKey: "details")
                relation.add(self.details)

                self.selectedMovie.saveInBackground() {(succeeded, error)  in
                    if (succeeded) {
                        // Detail successfully added
                    } else if let error = error {
                        print(error)
                    }
                }

                self.user.saveInBackground() {(succeeded, error)  in
                    if (succeeded) {
                        // Detail successfully added
                    } else if let error = error {
                        print(error)
                    }
                }
                self.view?.reloadFavoriteMoviesTableView()
            })
            .disposed(by: disposeBag)
    }

    func unfavorite() {
        self.view?.showIndicator(L10n.deleting)
		RxParse.deleteObject(details)
            .subscribe(onCompleted: {
                self.view?.hideIndicator()
                self.view?.updateFavButton()
                self.view?.reloadFavoriteMoviesTableView()
                self.view?.redirectToMenuScreen()
				self.selectedMovie.remove(forKey: L10n.childDetails)
                self.user.remove(forKey: "details")
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
