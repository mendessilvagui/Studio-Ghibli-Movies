//
//  DetailsViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 14/05/21.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var originalTitleRomanLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var rtScoreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentBox: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let database = DataBaseHandler.shared
    
    var selectedMovie: Movie? {
        didSet {
            loadFavorites()
        }
    }
    
    var favoriteArray = [Favorite]()
    
    var isFavorited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = selectedMovie?.title!.uppercased()
        titleLabel.numberOfLines = 0
        originalTitleLabel.text = selectedMovie?.original_title
        originalTitleRomanLabel.text = selectedMovie?.original_title_romanised
        directorLabel.text = selectedMovie?.director
        producerLabel.text = selectedMovie?.producer
        producerLabel.numberOfLines = 0
        producerLabel.sizeToFit()
        releaseDateLabel.text = selectedMovie?.release_date
        durationLabel.text = "\(selectedMovie?.running_time ?? "") min"
        rtScoreLabel.text = selectedMovie?.rt_score
        descriptionLabel.text = selectedMovie?.more_info
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        imageView.image = UIImage(named: "\(selectedMovie?.id ?? "").png")
        
        self.isFavorited = ((favoriteArray.last?.selected) != nil)
        self.updateRighBarButton(isFavorite: self.isFavorited)
        commentBox.text = favoriteArray.last?.comment
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
// MARK: - Updatade favorite button on touch

    func updateRighBarButton(isFavorite : Bool){
        let favButton = UIButton()
        favButton.addTarget(self, action: #selector(favButtonDidTap), for: .touchUpInside)

        if isFavorite {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
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
        self.updateRighBarButton(isFavorite: self.isFavorited);
    }
    
// MARK: - Add favorite and comment to database

    func favorite() {
        
        var textField = UITextField()
        
        let addAlert = UIAlertController(title: "Add to favorites", message: "", preferredStyle: .alert)
        
        addAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action: UIAlertAction!) in
            
            let newFavorite = Favorite(context: self.context)
            newFavorite.comment = textField.text
            newFavorite.selected = true
            newFavorite.parentMovie = self.selectedMovie
            
            self.favoriteArray.append(newFavorite)
            self.database.save()
            self.commentBox.text = self.favoriteArray.last?.comment
            
        }))

        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            addAlert.dismiss(animated: true, completion: nil)
            self.updateRighBarButton(isFavorite: false)
            self.isFavorited = false
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
            
            self.database.delete(object: self.favoriteArray.last!)
            self.database.save()
            self.commentBox.text = self.favoriteArray.last?.comment
        }))

        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            deleteAlert.dismiss(animated: true, completion: nil)
            self.updateRighBarButton(isFavorite: true)
            self.isFavorited = true
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }


//MARK: - Load favorite to view according to selected movie

    func loadFavorites(with request: NSFetchRequest<Favorite> = Favorite.fetchRequest(), predicate: NSPredicate? = nil) {

        let moviePredicate = NSPredicate(format: "parentMovie.title MATCHES %@", selectedMovie!.title!)

        print(moviePredicate)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [moviePredicate, additionalPredicate])
        } else {
            request.predicate = moviePredicate
        }

        do {
            favoriteArray = try context.fetch(request)
            print(favoriteArray)
        } catch {
            print("Error fetching dara from context \(error)")
        }
    }
}

