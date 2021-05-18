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
    
    var movie: MovieData?
    
    var favoriteArray = [Favorite]()
    
    var isFavorited = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie?.title.uppercased()
        titleLabel.numberOfLines = 0
        originalTitleLabel.text = movie?.original_title
        originalTitleRomanLabel.text = movie?.original_title_romanised
        directorLabel.text = movie?.director
        producerLabel.text = movie?.producer
        producerLabel.numberOfLines = 0
        producerLabel.sizeToFit()
        releaseDateLabel.text = movie?.release_date
        durationLabel.text = "\(String(describing: movie!.running_time)) min"
        rtScoreLabel.text = movie?.rt_score
        descriptionLabel.text = movie?.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        imageView.image = UIImage(named: "\(String(describing: movie!.id)).png")
        
        self.updateRighBarButton(isFavorite: self.isFavorited)
        
        loadFavorites()
        
    
//       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        //do your stuff
        self.isFavorited = !self.isFavorited;
        if self.isFavorited {
            self.favorite();
        }else{
            self.unfavorite();
        }
        self.updateRighBarButton(isFavorite: self.isFavorited);
    }
    
// MARK: - Add favorite and comment to database

    
    func favorite() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add to favorites", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // what will happen once the user clicks the Add Item Button on our UIAlert
           
            let newFavorite = Favorite(context: self.context)
            newFavorite.comment = textField.text
            newFavorite.selected = true
            
            self.favoriteArray.append(newFavorite)
            self.saveFavorites()
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Leave a comment"
            textField = alertTextField
        }
    
        
        present(alert, animated: true, completion: nil)
    }

// MARK: - Delete favorite and comment from database

    func unfavorite() {
        //do your unfavourite logic
    }


//MARK: - Data Manipulation Methods
    
    func saveFavorites() {
        do {
            try self.context.save()
        } catch {
            print("Error saving favorite \(error)")
        }
    }

    func loadFavorites() {

        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()

        do {
            favoriteArray = try context.fetch(request)
        } catch {
            print("Error fetching favorite \(error)")
        }
    }
}

