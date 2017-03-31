//
//  ViewController.swift
//  TabbarCustomTransform
//
//  Created by 飞流 on 2017/3/10.
//  Copyright © 2017年 飞流. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    fileprivate var interactionContoller = UIPercentDrivenInteractiveTransition()
    fileprivate var panGR: UIPanGestureRecognizer!
    fileprivate var interaction = false
    fileprivate var velocityX: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePanGR(_:)))
        panGR.delegate = self
        view.addGestureRecognizer(panGR)
    }
    
    func handlePanGR(_ panGR: UIPanGestureRecognizer) {
        var translationX = panGR.translation(in: view).x
        if (translationX > 0 && velocityX < 0) || (translationX < 0 && velocityX > 0) {
            translationX = 0.01
        }
        let translationAbs = translationX > 0 ? translationX : -translationX
        let percent = translationAbs / view.frame.width
        switch panGR.state {
        case .began:
            interaction = true
            velocityX = panGR.velocity(in: view).x
            if velocityX < 0 {
                if selectedIndex + 1 < viewControllers?.count ?? 0 {
                    selectedIndex += 1
                }
            } else {
                if selectedIndex > 0 {
                    selectedIndex -= 1
                }
            }
        case .changed:
            interactionContoller.update(percent)
        case .cancelled, .ended:
            interactionContoller.completionSpeed = 0.99
            if percent > 0.3 {
                interactionContoller.finish()
            } else {
                interactionContoller.cancel()
            }
            velocityX = 0
            interaction = false
        default:
            break
        }
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabbarCustomTransform(isContinuous: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interaction ? interactionContoller : nil
    }
}

extension MainViewController: UIGestureRecognizerDelegate  {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let selectedVC = selectedViewController as? UINavigationController else { return true }
        guard selectedVC.childViewControllers.count == 1 else { return false }
        let pointY = gestureRecognizer.location(in: view).y
        return pointY < UIScreen.main.bounds.size.height - tabBar.bounds.size.height
    }
}
