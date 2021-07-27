//
//  DetailsViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 14/05/21.

import UIKit
import Parse

class DetailsViewController: UIViewController, UINavigationControllerDelegate {

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
    public var delegate: ReloadList?

    private let presenter: DetailsPresenter

    // MARK: - Init

    init(selectedMovie: Movie) {
        presenter = DetailsPresenter(selectedMovie: selectedMovie)
        super.init(nibName: "DetailsView", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
        self.view.backgroundColor = UIColor(named: "totoro")
        
        navigationController?.delegate = self

        presenter.setView(view: self)
        presenter.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.loadMovieDetails()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.reloadList()
    }

// MARK: - Updatade favorite button on touch

    private func updateRightBarButton(){
        let favButton = UIButton()
        favButton.addTarget(self, action: #selector(favButtonDidTap), for: .touchUpInside)

        if self.isFavorited {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
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

        let addAlert = UIAlertController(title: "Add to favorites", message: "", preferredStyle: .alert)

        addAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction!) in
            self.presenter.favorite(withComment: textField.text ?? "")
        }))

        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            addAlert.dismiss(animated: true, completion: nil)
            self.isFavorited = false
            self.updateRightBarButton()
        }))

        addAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Leave a comment"
            textField = alertTextField
        }
        present(addAlert, animated: true, completion: nil)
    }

// MARK: - Delete favorite and comment from database

    private func unfavorite() {

        let deleteAlert = UIAlertController(title: "Delete from favorites?", message: "", preferredStyle: .alert)

        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            self.presenter.unfavorite()
        }))

        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
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
        titleLabel.backgroundColor = UIColor(named: "navBar")
        titleLabel.numberOfLines = 0
        originalTitleLabel.text =  selectedMovie.original_title
        originalTitleRomanLabel.text = selectedMovie.original_title_romanised
        directorLabel.text = selectedMovie.director
        producerLabel.text = selectedMovie.producer
        producerLabel.numberOfLines = 0
        producerLabel.sizeToFit()
        releaseDateLabel.text = selectedMovie.release_date
        durationLabel.text = "\(selectedMovie.running_time) min"
        rtScoreLabel.text = selectedMovie.rt_score
        descriptionLabel.text = selectedMovie.more_info
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        imageView.image = UIImage(named: "\(selectedMovie.movie_id).png")
    }

    func updateDetails(details: Detail) {
        if let selected = details["selected"] as? Bool { // TODO: refactor this line
            self.isFavorited = selected
        }
        commentBoxLabel.text = details.comment
        self.updateRightBarButton()
    }

    func updateComment(_ comment: String?) {
        self.commentBoxLabel.text = comment
    }

    func dismissScreen() {
        self.navigationController?.popViewController(animated: true)
    }
}
