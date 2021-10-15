//
//  AboutViewController.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 14/10/21.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var versionView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var createdByLabel: UILabel!

    //MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        styleViews()
        setupViews()
        fetchVersion()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "About"
    }

    // MARK: - Private methods

    private func styleViews() {
        Style.styleViewBackground(imageView: imageView)

        contactView.layer.cornerRadius = 10
        contactView.addShadowToView(color: UIColor.black.cgColor, radius: 5, offset: .zero, opacity: 0.5)
        versionView.layer.cornerRadius = 10
        versionView.addShadowToView(color: UIColor.black.cgColor, radius: 5, offset: .zero, opacity: 0.5)
        logoView.layer.cornerRadius = 10
        logoView.addShadowToView(color: UIColor.black.cgColor, radius: 5, offset: .zero, opacity: 0.5)
        logoImageView.layer.cornerRadius = 10

        createdByLabel.addShadowToView(color: UIColor.black.cgColor, radius: 3, offset: CGSize(width: 2, height: 2), opacity: 0.75)
        createdByLabel.layer.masksToBounds = false
    }

    private func setupViews() {
        let contactsTouchRecognizer = UITapGestureRecognizer(target: self, action: #selector(onEmailTouched))
        contactView.addGestureRecognizer(contactsTouchRecognizer)
    }

    private func fetchVersion() {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let buildNumber = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
            versionLabel.text = "\(version) (\(buildNumber))"
        } else {
            versionLabel.text = "???"
        }
    }

    // MARK: - Touch gestures

    @objc func onEmailTouched() {
        if let url = URL(string: "mailto:guimendes93@gmail.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
