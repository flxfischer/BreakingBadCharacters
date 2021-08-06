//
//  TransitionAnimator.swift
//  BreakingBadCharacters
//
//  Created by Felix Fischer on 06/08/2021.
//

import UIKit

class TransitioningCoordinator: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let fromVC = fromVC as? CharacterListViewController,
              let toVC = toVC as? CharacterDetailsViewController
        else { return nil }
        
        return TransitionAnimator(listViewController: fromVC, detailsViewController: toVC)
        
    }
}

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let cellImageViewRect: CGRect
    let listViewController: CharacterListViewController
    let detailsViewController: CharacterDetailsViewController
    
    init?(listViewController: CharacterListViewController, detailsViewController: CharacterDetailsViewController) {
        self.listViewController = listViewController
        self.detailsViewController = detailsViewController
        
        guard let window = listViewController.view.window ?? detailsViewController.view.window,
              let selectedCell = listViewController.selectedCell
        else { return nil }
        
        cellImageViewRect = selectedCell.convert(selectedCell.bounds, to: window)
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        guard let selectedCell = listViewController.selectedCell,
              let transitionCellImage = selectedCell.imageView.snapshotView(afterScreenUpdates: true)
        else { transitionContext.completeTransition(false); return }
        
        let transitionCellOriginalFrame = transitionCellImage.frame
        
        guard let toView = detailsViewController.view else { transitionContext.completeTransition(false); return }
        toView.layoutSubviews()
        
        transitionCellImage.frame = selectedCell.imageView.convert(selectedCell.imageView.frame, to: containerView)
        
        containerView.addSubview(listViewController.view)
        containerView.addSubview(toView)
        containerView.addSubview(transitionCellImage)
        
        toView.alpha = 0
        detailsViewController.imageView.alpha = 0
        
        UIView.animate(withDuration: duration) {
            transitionCellImage.frame = self.detailsViewController.imageView.convert(self.detailsViewController.imageView.frame, to: containerView)
            toView.alpha = 1
            self.listViewController.view.alpha = 0
        } completion: { _ in
            transitionCellImage.frame = transitionCellOriginalFrame
            self.listViewController.view.alpha = 1
            self.detailsViewController.imageView.alpha = 1
            transitionCellImage.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
