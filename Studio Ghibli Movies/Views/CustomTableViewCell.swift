//
//  CustomTableViewCell.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 30/06/21.
//

import UIKit
import Reusable

final class CustomTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var cellView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.backgroundColor = .clear
        self.selectionStyle = .none

        let containerHeightAnchor = self.contentView.heightAnchor.constraint(equalToConstant: 130)
        containerHeightAnchor.isActive = true
        self.cellView.layer.cornerRadius = 30
        self.cellView.backgroundColor = UIColor(named: "totoro")?.withAlphaComponent(0.8)

        self.titleLabel.textColor = UIColor.black
        self.subTitleLabel.textColor = UIColor.darkGray
        self.cellImageView.layer.cornerRadius = 10
    }

}
