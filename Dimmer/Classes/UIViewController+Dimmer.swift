//
//  UIViewController+Dimmer.swift
//  Pods
//
//  Created by DragonCherry on 5/12/17.
//
//

import UIViewKVO

extension UIViewController {
    
    open func hideLoading() {
        if let navigationController = self.navigationController {
            navigationController.view.hideLoading()
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            view.hideLoading()
        }
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    public func showLoading(alpha: CGFloat = 0.4) {
        hideLoading()
        navigationController?.navigationBar.isUserInteractionEnabled = false
        if let navigationController = self.navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
            navigationController.view.showLoading(alpha: alpha)
        } else {
            view.showLoading(alpha: alpha)
        }
    }
}
