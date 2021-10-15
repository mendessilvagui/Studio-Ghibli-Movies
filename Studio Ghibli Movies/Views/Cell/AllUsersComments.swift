//
//  AllUsersComments.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 15/10/21.
//

import UIKit
import Reusable

class AllUsersComments: UITableViewCell, NibReusable {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deletePressed(_ sender: UIButton) {
        
    }
}
