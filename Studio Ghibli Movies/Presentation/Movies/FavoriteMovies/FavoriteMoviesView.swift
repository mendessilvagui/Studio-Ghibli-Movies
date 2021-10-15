//
//  FavoriteMoviesView.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import Foundation

protocol FavoriteMoviesView: AnyObject {
    func reloadTableView()
    func checkIfListIsEmpty()
}
