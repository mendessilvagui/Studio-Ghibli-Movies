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

        self.title = "Movies"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBar")
        navigationController?.navigationBar.tintColor = UIColor.white

        setUpSearchController()
        presenter.searchController.searchBar.delegate = self
        presenter.searchController.searchResultsUpdater = self

        styleTableViewBackground()
        tableView.delegate = self
        tableView.dataSource = self
        registerTableViewCells()

        if presenter.movies.count != 0 {
            return
        }

        presenter.setView(view: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadMoviesList()
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Movie", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
}

//MARK: - SearchBar Results and Delegate Methods

extension MoviesViewController: UISearchResultsUpdating {
    internal func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        presenter.filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    internal func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        presenter.filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

// MARK: - TableView DataSource and Delegate Methods

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {

    private func registerTableViewCells() {
        let customCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(customCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }

    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        presenter.searchController.searchBar.endEditing(true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.isFiltering() {
            return presenter.filteredMovies.count
        }
        return presenter.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let movie: Movie

        if presenter.isFiltering() {
            movie = presenter.filteredMovies[indexPath.row]
        } else {
            movie = presenter.movies[indexPath.row]
        }

        let title = movie.title
        let subTitle = movie.originalTitle
        let id = movie.movieID

        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {

            cell.titleLabel.text = title
            cell.subTitleLabel.text = subTitle
            cell.cellImageView.image = UIImage(named: "poster-\(id)")
            return cell
        }
        return UITableViewCell()
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let indexPath = tableView.indexPathForSelectedRow {

            let movie = presenter.isFiltering() ? presenter.filteredMovies[indexPath.row] : presenter.movies[indexPath.row]

            let detailVC = DetailsViewController(selectedMovie: movie)
            detailVC.moviesVC = self
            detailVC.moviesVCDelegate = self
            tableView.deselectRow(at: (tableView.indexPathForSelectedRow)!, animated: false)

            self.show(detailVC, sender: self)
        }
        self.presenter.searchController.searchBar.endEditing(true)
    }
}

//MARK: - Set up SearchController and TableView background

extension MoviesViewController: MoviesView {

    func setUpSearchController() {
        navigationItem.searchController = presenter.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        presenter.searchController.obscuresBackgroundDuringPresentation = false
        presenter.searchController.searchBar.sizeToFit()
        presenter.searchController.searchBar.searchBarStyle = .minimal
        presenter.searchController.searchBar.scopeButtonTitles = ["All", "Favorites"]
        presenter.searchController.searchBar.searchTextField.textColor = UIColor.white
    }

    func styleTableViewBackground() {

        let image = UIImage(named: "TOTORO")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill

        let backView = UIView(frame: imageView.bounds)
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        imageView.addSubview(backView)

        tableView.backgroundView = imageView
        tableView.separatorStyle = .none
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Protocol to reload filtered movies list when coming back from DetailViewController

protocol ReloadList {
    func reloadList()
}

extension MoviesViewController: ReloadList {

    func reloadList() {
        presenter.filterContentForSearchText(searchText: presenter.currentText, scope: presenter.currentScope)
    }
}

