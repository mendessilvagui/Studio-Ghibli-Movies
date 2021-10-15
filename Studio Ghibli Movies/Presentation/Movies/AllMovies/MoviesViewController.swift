//
//  ViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 15/05/21.

import UIKit
import Parse

class MoviesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    private let presenter = MoviesPresenter()

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
        self.tabBarController?.navigationItem.title = "Movies"
        presenter.loadMoviesList()
    }
}

// MARK: - TableView DataSource and Delegate methods

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let movie: Movie

        movie = presenter.movies[indexPath.row]

        let cell = tableView.dequeueReusableCell(for: indexPath) as CustomTableViewCell

        cell.titleLabel.text = movie.title
        //cell.subTitleLabel.text = movie.originalTitle
		cell.posterImageView.image = UIImage(named: L10n.poster+"\(movie.movieID)")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let indexPath = tableView.indexPathForSelectedRow {

            let movie = presenter.movies[indexPath.row]

            let detailVC = DetailsViewController(selectedMovie: movie)
            detailVC.moviesVC = self
            tableView.deselectRow(at: (tableView.indexPathForSelectedRow)!, animated: false)

            self.show(detailVC, sender: self)
        }
    }
}

//MARK: - ReloadTableView and MoviesView protocols methods

extension MoviesViewController: ReloadTableView, MoviesView {

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
