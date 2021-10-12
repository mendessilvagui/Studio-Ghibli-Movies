//
//  DetailsViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 14/05/21.

import UIKit
import Parse
import MBProgressHUD

class DetailsViewController: UIViewController, UINavigationControllerDelegate {

	@IBOutlet private weak var backgroundImageView: UIImageView!
	@IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var originalTitleLabel: UILabel!
    @IBOutlet private weak var originalTitleRomanLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var rtScoreLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var producerLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var commentBoxLabel: UILabel!

    private var isFavorited: Bool = false
    public var moviesVC = MoviesViewController()
    public var favoriteMoviesVC = FavoriteMoviesViewController()
    public var favoriteMoviesVCDelegate: ReloadTableView?

    private let presenter: DetailsPresenter

    // MARK: - Init

    init(selectedMovie: Movie) {
        presenter = DetailsPresenter(selectedMovie: selectedMovie)
		super.init(nibName: L10n.detailsViewController, bundle: nil)
    }

    required init?(coder: NSCoder) {
		fatalError(L10n.initError)
    }

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = L10n.details
		//self.view.backgroundColor = UIColor(named: L10n.totoroBeige)

        self.navigationController?.delegate = self
        self.navigationItem.largeTitleDisplayMode = .never

        presenter.setView(view: self)
        presenter.start()
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter.loadMovieDetails()
    }
// MARK: - Updatade favorite button on touch

    private func updateRightBarButton(){
        let favButton = UIButton()
        favButton.addTarget(self, action: #selector(favButtonDidTap), for: .touchUpInside)

        if self.isFavorited {
			favButton.setImage(UIImage(systemName: L10n.heartFill), for: .normal)
        } else {
			favButton.setImage(UIImage(systemName: L10n.heart), for: .normal)
        }
        let rightButton = UIBarButtonItem(customView: favButton)
        self.navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }

    @objc private func favButtonDidTap() {
        self.isFavorited = !self.isFavorited;
        if self.isFavorited {
            self.favorite();
        } else {
            self.unfavorite();
        }
        self.updateRightBarButton();
    }

// MARK: - Add favorite and comment to database

    private func favorite() {

        var textField = UITextField()

		let addAlert = UIAlertController(title: L10n.addToFavorites, message: "", preferredStyle: .alert)

		addAlert.addAction(UIAlertAction(title: L10n.add, style: .default, handler: { (action: UIAlertAction!) in
			self.showIndicator(L10n.saving)
            self.presenter.favorite(withComment: textField.text ?? "")
            self.hideIndicator()
        }))

		addAlert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel, handler: { (action: UIAlertAction!) in
            addAlert.dismiss(animated: true, completion: nil)
            self.isFavorited = false
            self.updateRightBarButton()
        }))

        addAlert.addTextField { (alertTextField) in
			alertTextField.placeholder = L10n.leaveAComment
            textField = alertTextField
        }
        present(addAlert, animated: true, completion: nil)
    }

// MARK: - Delete favorite and comment from database

    private func unfavorite() {

		let deleteAlert = UIAlertController(title: L10n.deleteFromFavorites, message: "", preferredStyle: .alert)

		deleteAlert.addAction(UIAlertAction(title: L10n.delete, style: .destructive, handler: { (action: UIAlertAction!) in
			self.showIndicator(L10n.deleting)
            self.presenter.unfavorite()
            self.hideIndicator()
        }))

		deleteAlert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: true, completion: nil)

            self.isFavorited = true
            self.updateRightBarButton()
        }))
        present(deleteAlert, animated: true, completion: nil)
    }
}

extension DetailsViewController: DetailsView {

    func showMovieData(_ selectedMovie: Movie) {
        titleLabel.text = selectedMovie.title
		titleLabel.backgroundColor = UIColor(named: L10n.totoroGray)?.withAlphaComponent(0.9)
        originalTitleLabel.text =  selectedMovie.originalTitle
        originalTitleRomanLabel.text = selectedMovie.originalTitleRomanised
        directorLabel.text = selectedMovie.director
        producerLabel.text = selectedMovie.producer
        producerLabel.sizeToFit()
        releaseDateLabel.text = selectedMovie.releaseDate
        durationLabel.text = "\(selectedMovie.runningTime) min"
        rtScoreLabel.text = selectedMovie.rtScore
        descriptionLabel.sizeToFit()
		descriptionLabel.text = selectedMovie.moreInfo
        imageView.image = UIImage(named: "\(selectedMovie.movieID).png")
		backgroundImageView.image = UIImage(named: L10n.poster+"\(selectedMovie.movieID)")
		Style.styleViewBackground(imageView: backgroundImageView)
    }

    func updateDetails(details: Details) {
        self.isFavorited = details.selected
        commentBoxLabel.text = details.comment
        self.updateRightBarButton()
    }

    func updateComment(_ comment: String?) {
        self.commentBoxLabel.text = comment
    }

    func showIndicator(_ title: String) {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = title
        indicator.minShowTime = 1
    }

    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    func reloadFavoriteMoviesTableView() {
        self.favoriteMoviesVCDelegate?.reloadTableView()
    }
}
