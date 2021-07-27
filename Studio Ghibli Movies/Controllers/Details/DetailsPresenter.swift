//
//  DetailsPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Dielson Sales on 19/07/21.
//

import Foundation
import Parse

class DetailsPresenter {

    private weak var view: DetailsView?

    private let database = DataBase()
    private var selectedMovie = Movie()
    private var details = Detail()

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
        database.loadDetails(selectedMovie: selectedMovie) { detail in
            if let detail = detail {
                self.details = detail
            }
            self.view?.updateDetails(details: self.details)
        }
    }

    func favorite(withComment comment: String) {

        self.details.selected = true
        self.details.comment = comment
        self.details.parentMovie = selectedMovie

        // TODO: show loader
        database.save(object: details) { _ in
            self.selectedMovie.childDetail = self.details
            self.selectedMovie.saveInBackground() {(succeeded, error)  in
                // TODO: hide loader
                if (succeeded) {
                    self.view?.updateComment(comment)
                } else {
                    // TODO: show error
                }
            }
        }
    }

    func unfavorite() {
        database.delete(object: details)

        // TODO: show loader
        selectedMovie.remove(forKey: "childDetail")
        selectedMovie.saveInBackground() {(succeeded, error)  in
            if (succeeded) {
                self.view?.dismissScreen()
            } else {
                // TODO: show error
            }
        }
    }
}
