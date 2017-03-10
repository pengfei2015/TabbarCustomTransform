//
//  CustomTransform.swift
//  TabbarCustomTransform
//
//  Created by 飞流 on 2017/3/10.
//  Copyright © 2017年 飞流. All rights reserved.
//

import UIKit

class CustomTransform: NSObject {

    var isContinuous: Bool
    init(isContinuous: Bool = false) {
        self.isContinuous = isContinuous
        super.init()
    }
}

extension CustomTransform: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromeVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        guard let tbc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController, let fromeIndex = tbc.viewControllers?.index(where: { $0 == fromeVC}), let toIndex = tbc.viewControllers?.index(where: { $0 == toVC}) else { return }
        // 计算所有的开始frame  
        var offset = toIndex - fromeIndex // 2
        if !isContinuous {
            offset = toIndex > fromeIndex ? 1 : -1
        }
        var startFrames = [(UIView, CGRect)]()
        
        for i in 0...Int(abs(offset)) {
            let index = offset > 0 ? fromeIndex + i : fromeIndex - i
            let wOffset = offset > 0 ? i : -i
            var view: UIView!
            if isContinuous {
                view = tbc.viewControllers?[index].view
            } else {
                view = tbc.viewControllers?[toIndex].view
            }
            var temp = containerView.frame
            temp.origin.x = temp.size.width * CGFloat(wOffset)
            view?.frame = temp
            containerView.addSubview(view!)
            startFrames.append((view!, temp))
        }
        let endFrames = startFrames.map { (view, frame) -> (UIView, CGRect) in
            var temp = frame
            temp.origin.x = temp.origin.x - temp.size.width * CGFloat(offset)
            return (view, temp)
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.4, animations: {
            endFrames.forEach({
                $0.0.frame = $0.1
            })
        }, completion: { _ in
            transitionContext.completeTransition(true)
            UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
}
