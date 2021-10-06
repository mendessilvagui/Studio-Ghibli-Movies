//
//  FavoriteMoviesView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import Foundation
import Parse

protocol FavoriteMoviesView: NSObject {
    func reloadTableView()
    func checkIfListIsEmpty()
}
