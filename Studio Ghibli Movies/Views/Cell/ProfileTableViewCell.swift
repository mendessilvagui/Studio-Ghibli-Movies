//
//  ProfileTableViewCell.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 06/10/21.
//

import UIKit
import Reusable

class ProfileTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    static let height: CGFloat = 60

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        accessoryType = .disclosureIndicator
        backgroundColor = UIColor(named: L10n.totoroColor)?.withAlphaComponent(0.9)
        tintColor = .darkGray
        setUpAccessory()
    }

    private func setUpAccessory() {
        let image = UIImage(systemName: "chevron.right")
        let accessory  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!))
        accessory.image = image
        accessory.tintColor = .darkGray
        accessoryView = accessory
    }

    func setCellType(_ type: ProfileTableViewType) {
        switch type {
        case .accountData:
            titleLabel.text = "Register Data"
            iconImage.image = UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate)
        case .changePassword:
            titleLabel.text = "Change Password"
            iconImage.image = UIImage(systemName: "lock")?.withRenderingMode(.alwaysTemplate)
        case .logout:
            titleLabel.text = "Logout"
            iconImage.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
