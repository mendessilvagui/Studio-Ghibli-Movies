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

    func displayCancellableMessage(_ message: String,
                                   withTitle title: String,
                                   buttonTitle: String?,
                                   confirmAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: L10n.cancel, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: buttonTitle ?? L10n.ok, style: UIAlertAction.Style.default) { _ in
            confirmAction()
        })
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

    // MARK: Dismiss keyboard

    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}
