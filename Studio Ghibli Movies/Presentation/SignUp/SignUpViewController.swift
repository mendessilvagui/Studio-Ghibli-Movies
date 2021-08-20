//
//  SignUpViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import UIKit

class SignUpViewController: UIViewController, SignUpView {

    @IBOutlet weak var imageView: UIImageView!
    private let presenter: SignUpPresenter

    init() {
        presenter = SignUpPresenter()
        super.init(nibName: "SignUpViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(L10n.initError)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true

        presenter.setView(view: self)

        StyleBackground.styleViewBackground(imageView: imageView)
    }
}
