//
//  CustomTableViewCell.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 30/06/21.
//

import UIKit
import Reusable

final class CustomTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var outerPosterView: UIView!
	@IBOutlet weak var innerPosterView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backgroundColor = .clear

        let containerHeightAnchor = self.contentView.heightAnchor.constraint(equalToConstant: 225)
        containerHeightAnchor.isActive = true
        outerPosterView.layer.cornerRadius = 10
		outerPosterView.layer.shadowColor = UIColor.black.cgColor
		outerPosterView.layer.shadowRadius = 5
		outerPosterView.layer.shadowOpacity = 0.75

		innerPosterView.layer.cornerRadius = 10
		innerPosterView.layer.shadowColor = UIColor.black.cgColor
		innerPosterView.layer.shadowRadius = 5
		innerPosterView.layer.shadowOffset = CGSize.zero
		innerPosterView.layer.shadowOpacity = 1

		posterImageView.layer.cornerRadius = 10

		//self.cellView.backgroundColor = UIColor(named: L10n.totoroBeige)?.withAlphaComponent(0.9)

        titleLabel.textColor = UIColor.white
		titleLabel.layer.shadowColor = UIColor.black.cgColor
		titleLabel.layer.shadowRadius = 3.0
		titleLabel.layer.shadowOpacity = 1.0
		titleLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
		titleLabel.layer.masksToBounds = false
        //self.subTitleLabel.textColor = UIColor.white
    }
}
