//
//  FavoriteMoviesViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 05/10/21.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private let presenter = FavoriteMoviesPresenter()
    
    //MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleTableViewBackground(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: CustomTableViewCell.self)

        presenter.setView(view: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Favorites"
        presenter.loadFavoriteMoviesList()
    }
}

// MARK: - TableView DataSource and Delegate methods

extension FavoriteMoviesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return presenter.favoritedMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let movie: Movie

        movie = presenter.favoritedMovies[indexPath.row]

        let cell = tableView.dequeueReusableCell(for: indexPath) as CustomTableViewCell

        cell.titleLabel.text = movie.title
		cell.posterImageView.image = UIImage(named: L10n.poster+"\(movie.movieID)")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let indexPath = tableView.indexPathForSelectedRow {

            let movie = presenter.favoritedMovies[indexPath.row]

            let detailVC = DetailsViewController(selectedMovie: movie)
            detailVC.favoriteMoviesVC = self
            detailVC.favoriteMoviesVCDelegate = self
            tableView.deselectRow(at: (tableView.indexPathForSelectedRow)!, animated: false)

            self.show(detailVC, sender: self)
        }
    }
}

// MARK: - ReloadTableView and MoviesView protocols methods

extension FavoriteMoviesViewController: ReloadTableView, FavoriteMoviesView {

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func checkIfListIsEmpty() {
        if presenter.favoritedMovies.count == 0 {
            let tableHeaderView = HeaderTableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
            tableHeaderView.backgroundColor = UIColor(named: L10n.totoroBeige)
            tableView.tableHeaderView = tableHeaderView
        } else {
            tableView.tableHeaderView = nil
        }
    }
}
