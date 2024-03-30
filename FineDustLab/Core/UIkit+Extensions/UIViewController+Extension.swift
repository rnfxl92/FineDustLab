//
//  UIViewController+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 2023/02/20.
//  
//

import UIKit

extension UIViewController {
    public func showAlert(_ message: String,
                          title: String? = nil,
                          defaultTitle: String,
                          cancelTitle: String? = nil,
                          handler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: defaultTitle, style: .default, handler: handler)
            alert.addAction(defaultAction)
            if let cancelTitle = cancelTitle {
                alert.preferredAction = defaultAction
                alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
            }
            self.present(alert, animated: true)
        }
    }
    
    public func present(vc: UIViewController, animated: Bool) {
        if let parent = presentingViewController {
            parent.dismiss(animated: animated) {
                parent.present(vc, animated: animated)
            }
        } else {
            present(vc, animated: animated)
        }
    }
}

public extension UIViewController {
    enum BackType {
        case close
        case back
    }
}
