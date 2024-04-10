//
//  BottomSheetPresentable.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import UIKit
import SnapKit

public enum BottomSheet {
    public enum ModalSizing {
        /// dynamic height
        case intrinsic
        case max
//        case fixed(CGFloat) // TODO or removed
//        case scrollable(UIScrollView) // TODO
    }
    
    public typealias LayoutType = UIViewController & BottomSheetPresentable
}

public protocol BottomSheetTransitionDelegate: AnyObject {
    func presentationTransitionWillBegin()
    func presentationTransitionDidEnd(completed: Bool)
    
    func dismissalTransitionWillBegin()
    func dismissalTransitionDidEnd(completed: Bool)
    
    func dismissalCancelInteractiveTransition()
    func dismissalFinishInteractiveTransition()
}

public extension BottomSheetTransitionDelegate {
    func dismissalTransitionWillBegin() { }
    func dismissalTransitionDidEnd(completed: Bool) { }
    func presentationTransitionWillBegin() { }
    func presentationTransitionDidEnd(completed: Bool) { }
    
    func dismissalCancelInteractiveTransition() { }
    func dismissalFinishInteractiveTransition() { }
}

public protocol BottomSheetPresentable: BottomSheetTransitionDelegate {
    // default design guide property
    var preferredSheetTopInset: CGFloat { get }
    var preferredSheetCornerRadius: CGFloat { get }
    var preferredSheetSizing: BottomSheet.ModalSizing { get }
    var preferredSheetDimmedColor: UIColor { get }
    var tapToDismissEnabled: Bool { get }
    var pullToDismissEnabled: Bool { get }
    var dimmedViewTapHandler: (() -> Void)? { get }
}

public protocol FeedBackBottomSheetPresentable: BottomSheetPresentable {
    associatedtype FeedBack
}

public extension BottomSheetPresentable {
    var preferredSheetTopInset: CGFloat { 100 }
    var preferredSheetCornerRadius: CGFloat { 20 }
    var preferredSheetSizing: BottomSheet.ModalSizing { .intrinsic }
    var preferredSheetDimmedColor: UIColor { .black }
    var tapToDismissEnabled: Bool { true }
    var pullToDismissEnabled: Bool {
        // TODO: need to add interactor handler with scroll view or static view
        false
    }
    var dimmedViewTapHandler: (() -> Void)? { nil }
}

public extension UIViewController {
    func presentBottomSheet(
        _ viewControllerToPresent: BottomSheet.LayoutType,
        completion: (() -> Void)? = nil
    ) {
        viewControllerToPresent.modalPresentationStyle = .custom
        viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
        viewControllerToPresent.transitioningDelegate = BottomSheetTransitioning.build(viewControllerToPresent)
        present(
            viewControllerToPresent,
            animated: true,
            completion: completion
        )
    }
}

public extension Presentable {
    func presentBottomSheet(
        _ viewControllerToPresent: BottomSheet.LayoutType,
        completion: (() -> Void)? = nil
    ) {
        viewController.presentBottomSheet(
            viewControllerToPresent,
            completion: completion
        )
    }
}
