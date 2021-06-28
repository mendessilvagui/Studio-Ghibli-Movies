//
//  DetailsViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 14/05/21.

import UIKit
import Parse

class DetailsViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var originalTitleRomanLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var rtScoreLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentBoxLabel: UILabel!
    
    let database = DataBase()
    var isFavorited: Bool = false
    var selectedMovie = PFObject(className: "Movie")
    var details = PFObject(className:"Detail")
//    let moviesVC = MoviesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
        self.view.backgroundColor = UIColor(named: "totoro")
    
        showMovieData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        database.loadDetails(selectedMovie: selectedMovie) { object in
            if let object = object {
                self.details = object
            }
            self.updateDetails()
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if self.isMovingFromParent {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
//        }
//    }
    
    //MARK: - Show Movie data on screen
    
    func showMovieData() {
        
        titleLabel.text = selectedMovie["title"] as? String
        titleLabel.backgroundColor = UIColor(named: "navBar")
        titleLabel.numberOfLines = 0
        originalTitleLabel.text =  selectedMovie["original_title"] as? String
        originalTitleRomanLabel.text = selectedMovie["original_title_romanised"] as? String
        directorLabel.text = selectedMovie["director"] as? String
        producerLabel.text = selectedMovie["producer"] as? String
        producerLabel.numberOfLines = 0
        producerLabel.sizeToFit()
        releaseDateLabel.text = selectedMovie["release_date"] as? String
        durationLabel.text = "\(selectedMovie["running_time"] as? String ?? "") min"
        rtScoreLabel.text = selectedMovie["rt_score"] as? String
        descriptionLabel.text = selectedMovie["more_info"] as? String
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        imageView.image = UIImage(named: "\(selectedMovie["movie_id"] as? String ?? "").png")
    }

//MARK: - Update details to DetailsViewController

    func updateDetails() {
        
        if let selected = details["selected"] as? Bool {
            self.isFavorited = selected
        }
        commentBoxLabel.text = details["comment"] as? String
        self.updateRightBarButton()
    }

// MARK: - Updatade favorite button on touch

    func updateRightBarButton(){
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

    @objc func favButtonDidTap() {
        self.isFavorited = !self.isFavorited;
        if self.isFavorited {
            self.favorite();
        } else {
            self.unfavorite();
        }
        self.updateRightBarButton();
    }

// MARK: - Add favorite and comment to database

    func favorite() {

        var textField = UITextField()

        let addAlert = UIAlertController(title: "Add to favorites", message: "", preferredStyle: .alert)

        addAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction!) in
            
            self.details["selected"] = true
            self.details["comment"] = textField.text
            self.details["parentMovie"] = self.selectedMovie
            self.database.save(object: self.details)
            
            self.database.updateMovie(selectedMovie: self.selectedMovie) { object in
                object?["childDetail"] = self.details
                object?.saveInBackground()
            }
            
            self.commentBoxLabel.text = self.details["comment"] as? String
        
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

    func unfavorite() {

        let deleteAlert = UIAlertController(title: "Delete from favorites?", message: "", preferredStyle: .alert)

        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in

            self.database.delete(object: self.details)
            self.details = PFObject(className: "Detail")
            
            self.database.updateMovie(selectedMovie: self.selectedMovie) { object in
                object?.remove(forKey: "childDetail")
                object?.saveInBackground()
            }
            
            self.updateDetails()
        }))

        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: true, completion: nil)
            
            self.isFavorited = true
            self.updateRightBarButton()
        }))

        present(deleteAlert, animated: true, completion: nil)
    }
}
