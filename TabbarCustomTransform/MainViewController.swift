//
//  ViewController.swift
//  TabbarCustomTransform
//
//  Created by 飞流 on 2017/3/10.
//  Copyright © 2017年 飞流. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransform()
    }
}
