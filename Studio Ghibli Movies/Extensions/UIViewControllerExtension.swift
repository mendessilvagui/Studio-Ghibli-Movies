//
//  UIViewControllerExtension.swift
//  Studio Ghibli Movies
//
//  Created by Guilherme on 27/09/21.
//

import UIKit

extension UIViewController {

    // MARK: Show/Dismiss as Alert

    func showAsAlert(holderView: UIViewController) {
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        holderView.present(self, animated: true) { () -> Void in
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.backgroundColor  = UIColor.black.withAlphaComponent(0.5)
            })
        }
    }

    func dismissAsAlert(_ onCompletion: (() -> Void)?) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0)
        }, completion: { _ in
            self.dismiss(animated: true) {
                onCompletion?()
            }
        })
    }

    // MARK: Alerts

    func showAlert(title: String, message: String, buttonTitle: String, okTapAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default) { _ in
            okTapAction()
        })
        present(alert, animated: true, completion: nil)
    }

    func displaySimpleMessage(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(createOkAction())
        present(alertController, animated: true, completion: nil)
    }

    func displayMessage(_ message: String, withTitle title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(createOkAction())
        present(alertController, animated: true, completion: nil)
    }

    func displayCancellableMessage(withTitle title: String,
                                   buttonTitle: String?,
                                   cancelAction: @escaping () -> Void,
                                   confirmAction: @escaping () -> Void) {

        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel, handler: { (action: UIAlertAction!) in
            cancelAction()
        }))
        alert.addAction(UIAlertAction(title: buttonTitle ?? L10n.ok, style: .default, handler: { (action: UIAlertAction!) in
            confirmAction()
        }))
        present(alert, animated: true, completion: nil)
    }

    func displayErrorMessage(_ error: Error) {
        displayErrorMessage(error.localizedDescription)
    }

    func displayErrorMessage(_ message: String) {
        displayMessage(message, withTitle: L10n.error)
    }

    private func createOkAction() -> UIAlertAction {
        return UIAlertAction(title: L10n.ok, style: .default, handler: nil)
    }

    // MARK: Add/remove keyboard observer

    func addKeyboardOberserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    // MARK: Style backbground view

    func styleTableViewBackground(tableView: UITableView) {

        let image = UIImage(named: L10n.totoroImage)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill

        Style.styleViewBackground(imageView: imageView)

        tableView.backgroundView = imageView
        tableView.separatorStyle = .none
    }

    // MARK: Set navbar title size

    func setNavBarTitle(_ title: String, size: CGFloat) {
        self.title = title
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor(named: L10n.totoroGray)?.withAlphaComponent(0.9)
        appearance.titleTextAttributes =  [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
    }

    // MARK: Degrees to radians

    func radians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / degrees)
    }

    // MARK: Transition animation

    func addTransitionAnimation(_ subtype: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.20
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        transition.type = .moveIn
        transition.subtype = subtype
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
}
