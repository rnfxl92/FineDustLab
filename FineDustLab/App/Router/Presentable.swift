//
//  Presentable.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation
import UIKit

public protocol Presentable: AnyObject {
    var viewController: UIViewController { get }

    func setRoot(for window: UIWindow?)
    func present(_ presentable: Presentable, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func push(_ presentable: Presentable, animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool, completion: (() -> Void)?)
    func pop(to presentable: Presentable, animated: Bool)
    func popToRoot(animated: Bool, completion: (() -> Void)?)
    func set(_ presentables: [Presentable?], animated: Bool)
}

extension UIViewController: Presentable {
    public var viewController: UIViewController { self }
    public var topMostNavgationController: UINavigationController? {
        self as? UINavigationController ?? self.navigationController
    }
}

extension UIView: Presentable {
    public var viewController: UIViewController {
        viewController(for: self)
    }

    private func viewController(for responder: UIResponder) -> UIViewController {
        if let viewController = responder as? UIViewController {
            return viewController
        }

        if let window = responder as? UIWindow {
            return window.rootViewController ?? UIViewController()
        }

        if let nextResponder = responder.next {
            return viewController(for: nextResponder)
        }

        assertionFailure("ViewController를 찾지 못하였음")

        // TODO: - change to show error viewcontroller
        return UIViewController()

    }
}

extension Presentable {
    public func setRoot(for window: UIWindow?) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    public func present(_ presentable: Presentable, animated: Bool, completion: (() -> Void)? = nil) {
        if let vc = viewController.presentingViewController {
            dismiss(animated: animated) {
                vc.present(
                    presentable.viewController,
                    animated: animated,
                    completion: completion
                )
            }
        } else {
            viewController.present(
                presentable.viewController,
                animated: animated,
                completion: completion
            )
        }
    }
    
    public func presentFull(
        _ presentable: Presentable,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        presentable.viewController.modalPresentationStyle = .fullScreen
        viewController.present(
            presentable.viewController,
            animated: animated,
            completion: completion
        )
    }
    
    public func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        viewController.dismiss(animated: animated, completion: completion)
    }

    public func push(_ presentable: Presentable, animated: Bool, completion: (() -> Void)? = nil) {
        viewController.topMostNavgationController?
            .pushViewController(
                presentable.viewController,
                animated: animated
            ) {
                completion?()
            }
    }

    public func pop(animated: Bool, completion: (() -> Void)? = nil) {
        viewController.topMostNavgationController?
            .popViewController(
                animated: animated
            ) {
                completion?()
            }
    }

    public func pop(to presentable: Presentable, animated: Bool) {
        viewController.navigationController?
            .popToViewController(
                presentable.viewController,
                animated: animated
            )
    }

    public func popToRoot(animated: Bool, completion: (() -> Void)? = nil) {
        viewController.navigationController?
            .popToRootViewController(
                animated: animated
            ) {
                completion?()
            }
    }
    
    public func popToViewController(type: AnyClass, animated: Bool) {
        for vc in viewController.navigationController?.viewControllers ?? [] {
            guard vc.isKind(of: type) else { continue }
            
            viewController.navigationController?.popToViewController(vc, animated: animated)
            break
        }
    }

    public func set(_ presentables: [Presentable?], animated: Bool) {
        viewController.topMostNavgationController?
            .setViewControllers(
                presentables.compactMap({ $0?.viewController }),
                animated: animated
            )
    }
}

// https://stackoverflow.com/a/36809827
extension UINavigationController {
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        pushViewController(viewController, animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }

    public func popViewController(animated: Bool, completion: (() -> Void)? = nil) {
        popViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }

    public func popToRootViewController(animated: Bool, completion: (() -> Void)? = nil) {
        popToRootViewController(animated: animated)

        if animated, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }
}

