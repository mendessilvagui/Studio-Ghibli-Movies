//
//  DetailsViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme Mendes on 14/05/21.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailsTableView: UITableView!

    @IBOutlet weak var label: UILabel!
    
    var movieManager = MovieManager()

    var movieList = [MovieData]() {
        didSet {
            DispatchQueue.main.async {
                self.detailsTableView.reloadData()
            }
        }
    }

    var pickedMovie: MovieData?
    
    var index: Int!

    override func viewWillAppear(_ animated: Bool) {

        label.text = ("\(index ?? 0)")

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    

        // Do any additional setup after loading the view.
    }

    

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */
    

}
