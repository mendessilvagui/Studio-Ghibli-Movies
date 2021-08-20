//
//  LogInViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 19/08/21.
//

import UIKit

class LogInViewController: UIViewController, LogInView {

    @IBOutlet weak var imageView: UIImageView!
    private let presenter: LogInPresenter

    init() {
        presenter = LogInPresenter()
        super.init(nibName: "LogInViewController", bundle: nil)
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
