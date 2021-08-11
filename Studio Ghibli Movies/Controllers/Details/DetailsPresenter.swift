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

//    func loadMovieDetails() {
//        DataBase.loadDetails(selectedMovie: selectedMovie) { details in
//            if let details = details {
//                self.details = details
//            }
//            self.view?.updateDetails(details: self.details)
//        }
//    }

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

//    func favorite(withComment comment: String) {
//
//        self.details.selected = true
//        self.details.comment = comment
//        self.details.parentMovie = selectedMovie
//
//        DataBase.save(object: details) { _ in
//            self.selectedMovie.childDetails = self.details
//            self.selectedMovie.saveInBackground() {(succeeded, error)  in
//                if (succeeded) {
//                    self.view?.updateComment(comment)
//                } else if let error = error {
//                    print(error)
//                }
//            }
//        }
//    }

    func favorite(withComment comment: String) {

        self.details.selected = true
        self.details.comment = comment
        self.details.parentMovie = selectedMovie

        DataBase.save(object: details)
            .subscribe(onSuccess: { _ in
                self.selectedMovie.childDetails = self.details
                self.selectedMovie.saveInBackground() {(succeeded, error)  in
                    if (succeeded) {
                        self.view?.updateComment(comment)
                    } else if let error = error {
                        print(error)
                    }
                }
            })
            .disposed(by: disposeBag)
    }

//    func unfavorite() {
//        DataBase.delete(object: details)
//
//        selectedMovie.remove(forKey: "childDetails")
//        selectedMovie.saveInBackground() {(succeeded, error)  in
//            if (succeeded) {
//                // Detail successfully deleted
//            } else if let error = error {
//                print(error)
//            }
//        }
//    }

    func unfavorite() {
        DataBase.delete(object: details)
            .subscribe(onCompleted: {
                self.selectedMovie.remove(forKey: "childDetails")
                self.selectedMovie.saveInBackground() {(succeeded, error)  in
                    if (succeeded) {
                        // Detail successfully deleted
                    } else if let error = error {
                        print(error)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
