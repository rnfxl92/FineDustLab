//
//  BottomSheetTransitioning.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation
import UIKit
import SnapKit

enum BottomSheetTransitioning {
    private static let `default`: Delegate = {
        Delegate()
    }()
    
    static func build(_ presenter: BottomSheetPresentable) -> Delegate {
        BottomSheetTransitioning.default
            .setTransition(delegate: presenter)
            .setUIModel(
                BottomSheetTransitioning.UIModel(
                    preferredSheetTopInset: presenter.preferredSheetTopInset,
                    preferredSheetCornerRadius: presenter.preferredSheetCornerRadius,
                    preferredSheetSizing: presenter.preferredSheetSizing,
                    preferredSheetDimmedColor: presenter.preferredSheetDimmedColor,
                    tapToDismissEnabled: presenter.tapToDismissEnabled,
                    pullToDismissEnabled: presenter.pullToDismissEnabled,
                    dimmedViewTapHandler: presenter.dimmedViewTapHandler
                )
            )
    }
    
    struct UIModel {
        let preferredSheetTopInset: CGFloat
        let preferredSheetCornerRadius: CGFloat
        let preferredSheetSizing: BottomSheet.ModalSizing
        let preferredSheetDimmedColor: UIColor
        let tapToDismissEnabled: Bool
        let pullToDismissEnabled: Bool
        let dimmedViewTapHandler: (() -> Void)?
    }
    
    final class Delegate: NSObject, UIViewControllerTransitioningDelegate {
        private weak var presentationController: BottomSheetTransitioning.Presentation?
        private weak var transitionDelegate: BottomSheetTransitionDelegate?
        private var model = UIModel(
            preferredSheetTopInset: 0,
            preferredSheetCornerRadius: 0,
            preferredSheetSizing: .intrinsic,
            preferredSheetDimmedColor: .black,
            tapToDismissEnabled: true,
            pullToDismissEnabled: false,
            dimmedViewTapHandler: nil

        )
        
        fileprivate func setUIModel(_ model: UIModel) -> Self {
            self.model = model
            return self
        }
        
        fileprivate func setTransition(delegate: BottomSheetTransitionDelegate) -> Self {
            self.transitionDelegate = delegate
            return self
        }

        func presentationController(
            forPresented presented: UIViewController,
            presenting: UIViewController?,
            source: UIViewController
        ) -> UIPresentationController? {
            
            let bottomSheetPresentationController = BottomSheetTransitioning.Presentation(
                presentedViewController: presented,
                presenting: presenting ?? source,
                model: model,
                delegate: transitionDelegate
            )

            self.presentationController = bottomSheetPresentationController

            return bottomSheetPresentationController
        }

        func animationController(
            forDismissed dismissed: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
            guard
                let bottomSheetPresentationController = dismissed.presentationController as? BottomSheetTransitioning.Presentation,
                bottomSheetPresentationController.bottomSheetDismissTransition.wantsInteractiveStart
            else {
                return nil
            }

            return bottomSheetPresentationController.bottomSheetDismissTransition
        }

        func interactionControllerForDismissal(
            using animator: UIViewControllerAnimatedTransitioning
        ) -> UIViewControllerInteractiveTransitioning? {
            animator as? Dismiss
        }
    }
}

extension BottomSheetTransitioning {
    final class Presentation: UIPresentationController {
        private lazy var dimmedView: UIView = {
            let view = UIView()
            view.backgroundColor = model.preferredSheetDimmedColor
            view.alpha = 0
            return view
        }()

        private let model: UIModel
        fileprivate let bottomSheetDismissTransition: BottomSheetTransitioning.Dismiss
        private weak var transitionDelegate: BottomSheetTransitionDelegate?

        private var tapGestureRecognizer: UITapGestureRecognizer?
        private var panGestureRecognizer: UIPanGestureRecognizer?
        
        init(
            presentedViewController: UIViewController,
            presenting presentingViewController: UIViewController?,
            model: UIModel,
            delegate: BottomSheetTransitionDelegate?
        ) {
            self.model = model
            self.transitionDelegate = delegate
            self.bottomSheetDismissTransition = .init(
                transitionDelegate: transitionDelegate
            )
            
            super.init(
                presentedViewController: presentedViewController,
                presenting: presentingViewController
            )
            
            if model.tapToDismissEnabled {
                tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
                tapGestureRecognizer?.cancelsTouchesInView = false
            }
            
            if model.pullToDismissEnabled {
                panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan))
            }
        }

        // MARK: UIPresentationController
        override func presentationTransitionWillBegin() {
            defer {
                transitionDelegate?.presentationTransitionWillBegin()
            }
            
            guard let presentedView = presentedView else { return }

            if let panGestureRecognizer {
                presentedView.addGestureRecognizer(panGestureRecognizer)
            }

            presentedView.layer.cornerRadius = model.preferredSheetCornerRadius
            presentedView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
            ]

            guard let containerView = containerView else {
                return
            }

            if model.dimmedViewTapHandler != nil {
                let dimmedViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTap))
                containerView.addGestureRecognizer(dimmedViewTapGestureRecognizer)
            }

            if let tapGestureRecognizer {
                containerView.addGestureRecognizer(tapGestureRecognizer)
            }
            
            containerView.addSubview(dimmedView)
            dimmedView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }

            containerView.addSubview(presentedView)
            presentedView.snp.makeConstraints {
                switch model.preferredSheetSizing {
                case .intrinsic:
                    $0.top.greaterThanOrEqualTo(containerView.safeAreaLayoutGuide.snp.top)
                        .offset(model.preferredSheetTopInset)
                case .max:
                    $0.top.equalTo(containerView.safeAreaLayoutGuide.snp.top)
                        .offset(model.preferredSheetTopInset)
                }

                $0.leading.trailing.equalToSuperview()
                
                // for dismiss animation
                let bottom = $0.bottom.equalTo(containerView.snp.bottom)
                bottomSheetDismissTransition.bottomConstraint = bottom.constraint
            }
            
            guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
                return
            }

            transitionCoordinator.animate { _ in
                self.dimmedView.alpha = 0.3
            }
        }
        override func presentationTransitionDidEnd(_ completed: Bool) {
            defer {
                transitionDelegate?.presentationTransitionDidEnd(completed: completed)
            }
            
            guard completed.not else { return }
            dimmedView.removeFromSuperview()
            
            if let tapGestureRecognizer {
                containerView?.removeGestureRecognizer(tapGestureRecognizer)
            }
            
            if let panGestureRecognizer {
                presentedView?.removeGestureRecognizer(panGestureRecognizer)
            }
        }

        override func dismissalTransitionWillBegin() {
            defer {
                transitionDelegate?.dismissalTransitionWillBegin()
            }
            
            guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
                return
            }

            transitionCoordinator.animate { _ in
                self.dimmedView.alpha = 0
            }
        }
        
        override func dismissalTransitionDidEnd(_ completed: Bool) {
            defer {
                transitionDelegate?.dismissalTransitionDidEnd(completed: completed)
            }
            
            guard completed else { return }
            dimmedView.removeFromSuperview()
            
            if let tapGestureRecognizer {
                containerView?.removeGestureRecognizer(tapGestureRecognizer)
            }
            
            if let panGestureRecognizer {
                presentedView?.removeGestureRecognizer(panGestureRecognizer)
            }
        }

        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            panGestureRecognizer?.isEnabled = false
            coordinator.animate(alongsideTransition: nil) { _ in
                self.panGestureRecognizer?.isEnabled = true
            }
        }
    }
}

private extension BottomSheetTransitioning.Presentation {
    @objc func onTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard
            let presentedView = presentedView,
            let containerView = containerView,
            presentedView.frame.contains(gestureRecognizer.location(in: containerView)).not
        else {
            return
        }

        // call dismiss directly cause there is no cancel
        presentingViewController.presentedViewController?.dismiss(animated: true)
    }

    @objc func dimmedViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        model.dimmedViewTapHandler?()
    }

    @objc func onPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let presentedView = presentedView else { return }

        let translation = gestureRecognizer.translation(in: presentedView)
        let progress = translation.y / presentedView.frame.height
        
        switch gestureRecognizer.state {
        case .began:
            bottomSheetDismissTransition.start(
                moving: presentedView,
                interactiveDismissal: model.pullToDismissEnabled
            )
        case .changed:
            if model.pullToDismissEnabled && progress > 0 && !presentedViewController.isBeingDismissed {
                presentingViewController.dismiss(animated: true)
            }
            
            bottomSheetDismissTransition.move(
                presentedView, using: translation.y
            )
        default:
            let velocity = gestureRecognizer.velocity(in: presentedView)
            bottomSheetDismissTransition.stop(
                moving: presentedView,
                at: translation.y,
                with: velocity,
                presentedViewController: presentedViewController
            )
        }
    }
}

extension BottomSheetTransitioning {
    final class Dismiss: NSObject {

        private let stretchOffset: CGFloat = 16
        private let maxTransitionDuration: CGFloat = 0.25
        private let minTransitionDuration: CGFloat = 0.15
        private let animationCurve: UIView.AnimationCurve = .easeIn

        private weak var transitionContext: UIViewControllerContextTransitioning?
        private weak var transitionDelegate: BottomSheetTransitionDelegate?

        private var heightAnimator: UIViewPropertyAnimator?
        private var offsetAnimator: UIViewPropertyAnimator?
        
        private var interactiveDismissal: Bool = false
        var bottomConstraint: Constraint?
        var heightConstraint: Constraint?
        
        init(transitionDelegate: BottomSheetTransitionDelegate? = nil) {
            self.transitionDelegate = transitionDelegate
        }
        
        private func configureHeightAnimator(
            animating view: UIView,
            from height: CGFloat
        ) -> UIViewPropertyAnimator {
            let animator = UIViewPropertyAnimator(
                duration: minTransitionDuration,
                curve: animationCurve
            )
            heightConstraint?.update(offset: height)
            heightConstraint?.isActive = true
            
            let finalHeight = height + stretchOffset
            animator.addAnimations {
                self.heightConstraint?.update(offset: finalHeight)
                view.superview?.layoutIfNeeded()
            }
            
            animator.addCompletion {
                switch $0 {
                case .end:
                    self.heightConstraint?.update(offset: finalHeight)
                    self.heightConstraint?.isActive = true
                        
                default:
                    self.heightConstraint?.update(offset: height)
                    self.heightConstraint?.isActive = false
                }
            }
            
            return animator
        }

        private func configureOffsetAnimator(
            animating view: UIView,
            to offset: CGFloat
        ) -> UIViewPropertyAnimator {
            let animator = UIViewPropertyAnimator(
                duration: maxTransitionDuration,
                curve: animationCurve
            )

            animator.addAnimations {
                self.bottomConstraint?.update(offset: offset)
                view.superview?.layoutIfNeeded()
            }

            animator.addCompletion {
                switch $0 {
                case .end:
                    self.bottomConstraint?.update(offset: offset)
                default:
                    self.bottomConstraint?.update(offset: 0)
                }
            }

            return animator
        }

        private func stretchProgress(basedOn translation: CGFloat) -> CGFloat {
            (translation > 0 ? pow(translation, 0.33) : -pow(-translation, 0.33)) / stretchOffset
        }
    }
}

extension BottomSheetTransitioning.Dismiss {
    func start(moving presentedView: UIView, interactiveDismissal: Bool) {
        self.interactiveDismissal = interactiveDismissal
        heightAnimator?.stopAnimation(false)
        heightAnimator?.finishAnimation(at: .start)
        offsetAnimator?.stopAnimation(false)
        offsetAnimator?.finishAnimation(at: .start)
        heightAnimator = configureHeightAnimator(
            animating: presentedView,
            from: presentedView.frame.height
        )
        if !interactiveDismissal {
            offsetAnimator = configureOffsetAnimator(
                animating: presentedView, to: stretchOffset
            )
        }
    }

    func move(_ presentedView: UIView, using translation: CGFloat) {
        let progress = translation / presentedView.frame.height
        
        let stretchProgress = stretchProgress(basedOn: translation)
        
        heightAnimator?.fractionComplete = stretchProgress * -1
        offsetAnimator?.fractionComplete = interactiveDismissal ? progress : stretchProgress
        
        transitionContext?.updateInteractiveTransition(progress)
    }

    func stop(
        moving presentedView: UIView,
        at translation: CGFloat,
        with velocity: CGPoint,
        presentedViewController: UIViewController?
    ) {
        let progress = translation / presentedView.frame.height

        let stretchProgress = stretchProgress(basedOn: translation)

        heightAnimator?.fractionComplete = stretchProgress * -1
        offsetAnimator?.fractionComplete = interactiveDismissal ? progress : stretchProgress

        transitionContext?.updateInteractiveTransition(progress)

        let cancelDismiss = !interactiveDismissal || velocity.y < 500 || (progress < 0.5 && velocity.y <= 0)

        heightAnimator?.isReversed = true
        offsetAnimator?.isReversed = cancelDismiss
        
        if cancelDismiss {
            transitionContext?.cancelInteractiveTransition()
            transitionDelegate?.dismissalCancelInteractiveTransition()
            
        } else {
            transitionContext?.finishInteractiveTransition()
//            presentedViewController?.dismiss(animated: true)
            transitionDelegate?.dismissalFinishInteractiveTransition()
        }

        if progress < 0 {
            heightAnimator?.addCompletion { _ in
                self.offsetAnimator?.stopAnimation(false)
                self.offsetAnimator?.finishAnimation(at: .start)
            }
            heightAnimator?.startAnimation()
        } else {
            offsetAnimator?.addCompletion { _ in
                self.heightAnimator?.stopAnimation(false)
                self.heightAnimator?.finishAnimation(at: .start)
            }
            offsetAnimator?.startAnimation()
        }

        interactiveDismissal = false
    }
}

// MARK: UIViewControllerAnimatedTransitioning

extension BottomSheetTransitioning.Dismiss: UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedView = transitionContext.view(forKey: .from) else {
            return
        }

        offsetAnimator?.stopAnimation(true)

        let offset = presentedView.frame.height
        let offsetAnimator = configureOffsetAnimator(animating: presentedView, to: offset)

        offsetAnimator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        offsetAnimator.startAnimation()

        self.offsetAnimator = offsetAnimator
    }

    func interruptibleAnimator(
        using transitionContext: UIViewControllerContextTransitioning
    ) -> UIViewImplicitlyAnimating {
        guard let offsetAnimator = offsetAnimator else {
            assertionFailure("offset animator is nil..")
            return UIViewPropertyAnimator(
                duration: maxTransitionDuration,
                curve: animationCurve
            )
        }

        return offsetAnimator
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        maxTransitionDuration
    }
}

extension BottomSheetTransitioning.Dismiss: UIViewControllerInteractiveTransitioning {

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard
            transitionContext.isInteractive,
            let presentedView = transitionContext.view(forKey: .from)
        else {
            return animateTransition(using: transitionContext)
        }

        let fractionComplete = offsetAnimator?.fractionComplete ?? 0

        offsetAnimator?.stopAnimation(true)

        let offset = presentedView.frame.height
        let offsetAnimator = configureOffsetAnimator(animating: presentedView, to: offset)

        offsetAnimator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        offsetAnimator.fractionComplete = fractionComplete
        transitionContext.updateInteractiveTransition(fractionComplete)

        self.offsetAnimator = offsetAnimator
        self.transitionContext = transitionContext
    }

    var wantsInteractiveStart: Bool {
        interactiveDismissal
    }

    var completionCurve: UIView.AnimationCurve {
        animationCurve
    }

    var completionSpeed: CGFloat {
        1.0
    }
}
