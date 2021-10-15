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
        outerPosterView.addShadowToView(color: UIColor.black.cgColor, radius: 3, offset: .zero, opacity: 0.5)
		innerPosterView.layer.cornerRadius = 10
        innerPosterView.addShadowToView(color: UIColor.black.cgColor, radius: 5, offset: .zero, opacity: 1)
		posterImageView.layer.cornerRadius = 10

        titleLabel.textColor = UIColor.white
        titleLabel.addShadowToView(color: UIColor.black.cgColor, radius: 3, offset: CGSize(width: 2, height: 2), opacity: 0.75)
		titleLabel.layer.masksToBounds = false
    }
}
