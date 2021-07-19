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

    let presenter = DetailsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
        self.view.backgroundColor = UIColor(named: "totoro")
        
        navigationController?.delegate = self

        presenter.setView(view: self)
    
        showMovieData()
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
            
            self.presenter.details["selected"] = true
            self.presenter.details["comment"] = textField.text
            self.presenter.details["parentMovie"] = self.presenter.selectedMovie
            self.presenter.database.save(object: self.presenter.details) {_ in
                self.presenter.selectedMovie["childDetail"] = self.presenter.details
                self.presenter.selectedMovie.saveInBackground() {(succeeded, error)  in
                    if (succeeded) {
                        // Succeeded to save data.
                    }
                }
            }
            self.commentBoxLabel.text = self.presenter.details["comment"] as? String
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
            
            self.presenter.database.delete(object: self.presenter.details)
            self.presenter.details = PFObject(className: "Detail")
            
            self.presenter.selectedMovie.remove(forKey: "childDetail")
            self.presenter.selectedMovie.saveInBackground() {(succeeded, error)  in
                if (succeeded) {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
            self.updateDetails(details: self.presenter.details)
        }))

        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: true, completion: nil)
            
            self.isFavorited = true
            self.updateRightBarButton()
            
        }))
        present(deleteAlert, animated: true, completion: nil)
    }
}

//MARK: - Show Movie data on screen

extension DetailsViewController {
    
    private func showMovieData() {
        
        titleLabel.text = presenter.selectedMovie["title"] as? String
        titleLabel.backgroundColor = UIColor(named: "navBar")
        titleLabel.numberOfLines = 0
        originalTitleLabel.text =  presenter.selectedMovie["original_title"] as? String
        originalTitleRomanLabel.text = presenter.selectedMovie["original_title_romanised"] as? String
        directorLabel.text = presenter.selectedMovie["director"] as? String
        producerLabel.text = presenter.selectedMovie["producer"] as? String
        producerLabel.numberOfLines = 0
        producerLabel.sizeToFit()
        releaseDateLabel.text = presenter.selectedMovie["release_date"] as? String
        durationLabel.text = "\(presenter.selectedMovie["running_time"] as? String ?? "") min"
        rtScoreLabel.text = presenter.selectedMovie["rt_score"] as? String
        descriptionLabel.text = presenter.selectedMovie["more_info"] as? String
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        imageView.image = UIImage(named: "\(presenter.selectedMovie["movie_id"] as? String ?? "").png")
    }
}

extension DetailsViewController: DetailsView {

    func updateDetails(details: PFObject) {
        if let selected = details["selected"] as? Bool {
            self.isFavorited = selected
        }
        commentBoxLabel.text = details["comment"] as? String
        self.updateRightBarButton()
    }
}
