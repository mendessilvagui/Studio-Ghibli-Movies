//
//  DetailsViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 14/05/21.

import UIKit
import Parse
import MBProgressHUD

class DetailsViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet private weak var heartButtonView: UIView!
    @IBOutlet private weak var heartButton: UIButton!
    @IBOutlet private weak var readMoreButton: UIButton!
    @IBOutlet private weak var readMoreButtonView: UIView!
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


    @IBAction func favoritePressed(_ sender: UIButton) {
        self.isFavorited = !self.isFavorited
        if self.isFavorited {
            self.favorite()
        } else {
            self.unfavorite()
        }
    }

// MARK: - Add favorite and comment to database

    private func favorite() {

        displayCancellableMessage(withTitle: L10n.addToFavorites, buttonTitle: L10n.add) {
            self.isFavorited = false
        } confirmAction: {
            self.presenter.favorite()
        }
    }

// MARK: - Delete favorite and comment from database

    private func unfavorite() {

        displayCancellableMessage(withTitle: L10n.deleteFromFavorites, buttonTitle: L10n.delete) {
            self.isFavorited = true
        } confirmAction: {
            self.presenter.unfavorite()
        }
    }

    @IBAction func readMorePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        UIView.animate(withDuration: 0.5) {
            if sender.isSelected {
                self.descriptionLabel.numberOfLines = 0
                self.readMoreButton.transform = CGAffineTransform(rotationAngle: self.radians(180))
            } else {
                self.descriptionLabel.numberOfLines = 2
                self.readMoreButton.transform = .identity
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension DetailsViewController: DetailsView {

    func showMovieData(_ selectedMovie: Movie) {
        heartButtonView.layer.cornerRadius = 25
        heartButtonView.layer.masksToBounds = false
        heartButtonView.addShadowToView(color: UIColor.black.cgColor, radius: 10, offset: .zero, opacity: 1)
        readMoreButton.setTitleColor(.white, for: .normal)
        readMoreButton.setTitleColor(.white, for: .selected)
        readMoreButtonView.layer.cornerRadius = 18
        readMoreButtonView.layer.masksToBounds = true
        readMoreButton.backgroundColor = .black.withAlphaComponent(0.1)
        titleLabel.text = selectedMovie.title
		titleLabel.backgroundColor = UIColor(named: L10n.totoroGray)?.withAlphaComponent(0.25)
        titleLabel.addShadowToLabel(color: UIColor.black.cgColor, radius: 5, offset: CGSize(width: 0, height: 5), opacity: 1)
        originalTitleLabel.text =  selectedMovie.originalTitle
        originalTitleRomanLabel.text = selectedMovie.originalTitleRomanised
        directorLabel.text = selectedMovie.director
        producerLabel.text = selectedMovie.producer
        producerLabel.sizeToFit()
        releaseDateLabel.text = selectedMovie.releaseDate
        durationLabel.text = "\(selectedMovie.runningTime) min"
        rtScoreLabel.text = selectedMovie.rtScore
		descriptionLabel.text = selectedMovie.moreInfo
        imageView.image = UIImage(named: "\(selectedMovie.movieID).png")
		backgroundImageView.image = UIImage(named: L10n.poster+"\(selectedMovie.movieID)")
		Style.styleViewBackground(imageView: backgroundImageView)
    }

    func updateFavButton() {
        if isFavorited {
            heartButton.setImage(UIImage(systemName: L10n.heartFill), for: .normal)
        } else {
            heartButton.setImage(UIImage(systemName: L10n.heart), for: .normal)
        }
    }

    func updateDetails(details: Details) {
        isFavorited = details.selected
        updateFavButton()
    }

    func updateComment(_ comment: String?) {
        commentBoxLabel.text = comment
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
        favoriteMoviesVCDelegate?.reloadTableView()
    }
}
