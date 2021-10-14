//
//  DetailsView.swift
//  Studio Ghibli Movies
//
//  Created by Dielson Sales on 19/07/21.
//

import Foundation
import Parse

protocol DetailsView: NSObject {
    func showMovieData(_ selectedMovie: Movie)
    func updateFavButton()
    func updateDetails(details: Details)
    func updateComment(_ comment: String?)
    func showIndicator(_ title: String)
    func hideIndicator()
    func reloadFavoriteMoviesTableView()
}
