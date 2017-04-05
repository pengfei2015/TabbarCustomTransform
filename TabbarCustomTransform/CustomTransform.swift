//
//  CustomTransform.swift
//  TabbarCustomTransform
//
//  Created by 飞流 on 2017/3/10.
//  Copyright © 2017年 飞流. All rights reserved.
//

import UIKit

class TabbarCustomTransform: NSObject {
    
    var animating: Bool = false
    var isContinuous: Bool
    init(isContinuous: Bool = false) {
        self.isContinuous = isContinuous
        super.init()
    }
}

extension TabbarCustomTransform: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromeVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        guard let tbc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController, let fromeIndex = tbc.viewControllers?.index(where: { $0 == fromeVC}), let toIndex = tbc.viewControllers?.index(where: { $0 == toVC}) else { return }
        animating = true
        // 计算所有的开始frame
        var offset = toIndex - fromeIndex // 2
        if !isContinuous {
            offset = toIndex > fromeIndex ? 1 : -1
        }
        var endTransforms = [(view:UIView, transform:CGAffineTransform)]()
        let width = containerView.frame.size.width
        for i in 1...Int(abs(offset)) {
            let index = offset > 0 ? fromeIndex + i : fromeIndex - i
            let wOffset = offset > 0 ? i : -i
            var view: UIView!
            if isContinuous {
                view = tbc.viewControllers?[index].view
            } else {
                view = tbc.viewControllers?[toIndex].view
            }
            let startX = width * CGFloat(wOffset)
            let startTransform = CGAffineTransform(translationX: startX, y: 0)
            let endX = startX - width * CGFloat(offset)
            let endTransform = CGAffineTransform(translationX: endX, y: 0)
            containerView.addSubview(view)
            view.transform = startTransform
            endTransforms.append((view, endTransform))
        }

        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            endTransforms.forEach {
                $0.view.transform = $0.transform
            }
        }, completion: { _ in
            self.animating = false
            endTransforms.forEach {
                $0.view.transform = CGAffineTransform.identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        })
    }
}
