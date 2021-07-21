//
//  DetailsView.swift
//  Studio Ghibli Movies
//
//  Created by Dielson Sales on 19/07/21.
//

import Foundation

import Parse

protocol DetailsView: NSObject {
    func showMovieData(_ selectedMovie: PFObject)
    func updateDetails(details: PFObject)
    func updateComment(_ comment: String)
    func dismissScreen()
}
