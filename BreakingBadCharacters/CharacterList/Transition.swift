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
        
        if let fromVC = fromVC as? CharacterListViewController,
           let toVC = toVC as? CharacterDetailsViewController {
            return TransitionAnimator(listViewController: fromVC, detailsViewController: toVC, push: true)
        } else if let fromVC = fromVC as? CharacterDetailsViewController,
                  let toVC = toVC as? CharacterListViewController {
            return TransitionAnimator(listViewController: toVC, detailsViewController: fromVC, push: false)
        } else { return nil }
    }
}

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let push: Bool
    let cellImageViewRect: CGRect
    let listViewController: CharacterListViewController
    let detailsViewController: CharacterDetailsViewController
    
    init?(listViewController: CharacterListViewController, detailsViewController: CharacterDetailsViewController, push: Bool) {
        self.listViewController = listViewController
        self.detailsViewController = detailsViewController
        self.push = push
        
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
        
        guard let selectedCell = listViewController.selectedCell
        else { transitionContext.completeTransition(false); return }
        
        if push {
            guard let transitionCellImage = selectedCell.imageView.snapshotView(afterScreenUpdates: true)
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
        } else {
            let imageView = detailsViewController.imageView
                
            guard let transitionImageView = imageView.snapshotView(afterScreenUpdates: true)
            else { transitionContext.completeTransition(false); return }
            
            let transitionImageViewOriginalFrame = transitionImageView.frame
            
            guard let toView = listViewController.view
            else { transitionContext.completeTransition(false); return }
            toView.layoutSubviews()
            
            transitionImageView.frame = imageView.convert(imageView.frame, to: containerView)
            
            containerView.addSubview(detailsViewController.view)
            containerView.addSubview(toView)
            containerView.addSubview(transitionImageView)
            
            toView.alpha = 0
            listViewController.selectedCell?.imageView.alpha = 0
            
            UIView.animate(withDuration: duration) {
                transitionImageView.frame = selectedCell.imageView.convert(selectedCell.imageView.frame, to: containerView)
                toView.alpha = 1
                self.detailsViewController.view.alpha = 0
            } completion: { _ in
                transitionImageView.frame = transitionImageViewOriginalFrame
                self.listViewController.view.alpha = 1
                self.detailsViewController.view.alpha = 1
                selectedCell.imageView.alpha = 1
                transitionImageView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }

            
            
            
            
        }
        
    }
}
