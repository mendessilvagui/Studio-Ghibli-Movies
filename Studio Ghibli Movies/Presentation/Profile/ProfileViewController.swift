//
//  ProfileViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 05/10/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
	@IBOutlet weak var imageView: UIImageView!

    private let presenter = ProfilePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		styleView()
        setUpTableView()
        presenter.setView(view: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Profile"
    }

	private func styleView() {
		Style.styleViewBackground(imageView: imageView)
	}

    private func setUpTableView() {
        tableView.register(cellType: ProfileTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.alwaysBounceVertical = false
        tableView.layer.cornerRadius = 20
        tableView.tintColor = UIColor(named: L10n.totoroGray)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        switch indexPath.row {
        case 0:
            cell.setCellType(.accountData)
        case 1:
            cell.setCellType(.changePassword)
        case 2:
            cell.setCellType(.logout)
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ProfileTableViewCell.height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            presenter.onSelectEditUser()
        case 1:
            presenter.onSelectChangePassword()
        case 2:
            presenter.onSelectLogout()
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            if let cell: ProfileTableViewCell = tableView.cellForRow(at: indexPath) as? ProfileTableViewCell {
                UIView.animate(withDuration: 0.2) {
                    cell.backgroundColor = UIColor.gray
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            if let cell: ProfileTableViewCell = tableView.cellForRow(at: indexPath) as? ProfileTableViewCell {
                UIView.animate(withDuration: 0.2) {
                    cell.backgroundColor = UIColor(named: L10n.totoroBeige)?.withAlphaComponent(0.9)
                }
            }
        }
    }
}

extension ProfileViewController: ProfileView {

    func redirectToEditUser() {
        show(EditUserViewController(), sender: self)
    }

    func redirectToChangePasswordScreen() {
        show(ChangePasswordViewController(), sender: self)
    }

    func redirectToLoginScreen() {
        //switchRootViewController(LogInViewController(), animated: true, completion:  nil)
        show(LogInViewController(), sender: self)
    }
}
