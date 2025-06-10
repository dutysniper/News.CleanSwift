//
//  CustomPresentationController.swift
//  News.CleanSwift
//
//  Created by Константин Натаров on 10.06.2025.
//

import UIKit

final class CustomBottomSheetPresentationController: UIPresentationController {
	private let heightRatio: CGFloat = 0.2
	private let cornerRadius: CGFloat = 16
	private var dimmingView: UIView!

	override var frameOfPresentedViewInContainerView: CGRect {
		guard let containerView = containerView else { return .zero }

		let height = containerView.bounds.height * heightRatio
		return CGRect(
			x: 0,
			y: containerView.bounds.height - height,
			width: containerView.bounds.width,
			height: height
		)
	}

	override func presentationTransitionWillBegin() {
		super.presentationTransitionWillBegin()
		setupDimmingView()

		presentedView?.layer.cornerRadius = cornerRadius
		presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

		guard let coordinator = presentingViewController.transitionCoordinator else {
			dimmingView.alpha = 0.5
			return
		}

		coordinator.animate(alongsideTransition: { _ in
			self.dimmingView.alpha = 0.5
		})
	}

	override func dismissalTransitionWillBegin() {
		super.dismissalTransitionWillBegin()

		guard let coordinator = presentingViewController.transitionCoordinator else {
			dimmingView.alpha = 0
			return
		}

		coordinator.animate(alongsideTransition: { _ in
			self.dimmingView.alpha = 0
		})
	}

	override func containerViewDidLayoutSubviews() {
		super.containerViewDidLayoutSubviews()
		presentedView?.frame = frameOfPresentedViewInContainerView
		dimmingView.frame = containerView?.bounds ?? .zero
	}

	private func setupDimmingView() {
		dimmingView = UIView()
		dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		dimmingView.alpha = 0
		dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
		dimmingView.addGestureRecognizer(tapGesture)

		containerView?.insertSubview(dimmingView, at: 0)
	}

	@objc private func dimmingViewTapped() {
		presentingViewController.dismiss(animated: true)
	}
}

final class BottomSheetTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	private let isPresenting: Bool

	init(isPresenting: Bool) {
		self.isPresenting = isPresenting
		super.init()
	}

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.3
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		if isPresenting {
			animatePresentation(using: transitionContext)
		} else {
			animateDismissal(using: transitionContext)
		}
	}

	private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
		guard let toViewController = transitionContext.viewController(forKey: .to),
			  let toView = transitionContext.view(forKey: .to) else {
			transitionContext.completeTransition(false)
			return
		}

		let containerView = transitionContext.containerView
		toView.frame = transitionContext.finalFrame(for: toViewController)
		toView.transform = CGAffineTransform(translationX: 0, y: toView.frame.height)
		containerView.addSubview(toView)

		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: [.curveEaseOut],
			animations: {
				toView.transform = .identity
			},
			completion: { finished in
				transitionContext.completeTransition(finished)
			}
		)
	}

	private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
		guard let fromView = transitionContext.view(forKey: .from) else {
			transitionContext.completeTransition(false)
			return
		}

		UIView.animate(
			withDuration: transitionDuration(using: transitionContext),
			delay: 0,
			options: [.curveEaseIn],
			animations: {
				fromView.transform = CGAffineTransform(translationX: 0, y: fromView.frame.height / 10)
			},
			completion: { finished in
				transitionContext.completeTransition(finished)
			}
		)
	}
}

final class BottomSheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
	func presentationController(
		forPresented presented: UIViewController,
		presenting: UIViewController?,
		source: UIViewController
	) -> UIPresentationController? {
		return CustomBottomSheetPresentationController(
			presentedViewController: presented,
			presenting: presenting
		)
	}

	func animationController(
		forPresented presented: UIViewController,
		presenting: UIViewController,
		source: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		return BottomSheetTransitionAnimator(isPresenting: true)
	}

	func animationController(
		forDismissed dismissed: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		return BottomSheetTransitionAnimator(isPresenting: false)
	}
}
