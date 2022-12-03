//
//  AlertView.swift
//  FinalProject
//
//  Created by tu.le2 on 30/08/2022.
//

import UIKit

extension UIViewController {

    func showErrorDialog(message: String = "", completion: (() -> Void)?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
