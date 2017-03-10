//
//  CustomTransform.swift
//  TabbarCustomTransform
//
//  Created by 飞流 on 2017/3/10.
//  Copyright © 2017年 飞流. All rights reserved.
//

import UIKit

class CustomTransform: NSObject {

}

extension CustomTransform: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromeVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        let fromeStartFrame = transitionContext.initialFrame(for: fromeVC)
        let toEndFrame = transitionContext.finalFrame(for: toVC)
        guard let fromView = fromeVC.view, let toView = toVC.view else { return }
        guard let tbc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController, let fromeIndex = tbc.viewControllers?.index(where: { $0 == fromeVC}), let toIndex = tbc.viewControllers?.index(where: { $0 == toVC}) else { return }
        let dir: CGFloat = fromeIndex < toIndex ? 1 : -1
        // 计算fromeVC移动的位置
        var r = fromeStartFrame
        r.origin.x -= r.size.width * dir
        let fromeEndFrame = r
        r = toEndFrame
        r.origin.x += r.size.width * dir
        // 将toVC开始的位置
        let toStartFrame = r
        toView.frame = toStartFrame
        containerView.addSubview(toView)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.4, animations: {
            fromView.frame = fromeEndFrame
            toView.frame = toEndFrame
        }, completion: { _ in
            transitionContext.completeTransition(true)
            UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
}
