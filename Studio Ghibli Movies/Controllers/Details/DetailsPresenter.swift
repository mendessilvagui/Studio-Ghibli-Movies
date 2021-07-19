//
//  DetailsPresenter.swift
//  Studio Ghibli Movies
//
//  Created by Dielson Sales on 19/07/21.
//

import Foundation

import Parse

class DetailsPresenter {

    weak var view: DetailsView?

    let database = DataBase()
    var selectedMovie = PFObject(className: "Movie")
    var details = PFObject(className:"Detail")

    func setView(view: DetailsView) {
        self.view = view
    }

    // MARK: - Presenter methods

    func loadMovieDetails() {
        database.loadDetails(selectedMovie: selectedMovie) { object in
            if let object = object {
                self.details = object
            }
            self.view?.updateDetails(details: self.details)
        }
    }
}
