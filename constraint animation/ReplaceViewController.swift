//
//  ReplaceViewController.swift
//  constraint animation
//
//  Created by Christopher Trahey on 3/3/17.
//  Copyright © 2017 trahey. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func copyWith(_ oldItem:AnyObject, replacedWith newItem:AnyObject) -> NSLayoutConstraint {
        let newFirstItem = firstItem === oldItem ? newItem : firstItem
        let newSecondItem = secondItem === oldItem ? newItem : secondItem
        let newConst = NSLayoutConstraint(item: newFirstItem,
                                          attribute: firstAttribute,
                                          relatedBy: relation,
                                          toItem: newSecondItem,
                                          attribute: secondAttribute,
                                          multiplier: multiplier,
                                          constant: constant)
        newConst.identifier = identifier
        newConst.priority = priority
        return newConst
    }
}

extension UIView {
    
    typealias SwapConstraints = (old:NSLayoutConstraint, new:NSLayoutConstraint, owner:UIView)
    
    @discardableResult
    func replaceWith(_ newView:UIView) -> UIView {
        newView.frame = frame
        var ancestor:UIView? = self
        
        var swaps:[SwapConstraints] = []
        while (ancestor != nil) {
            for ancestorConstraint in ancestor!.constraints {
                if ancestorConstraint.firstItem === self || ancestorConstraint.secondItem === self {
                    let replacementConstraint = ancestorConstraint.copyWith(self, replacedWith: newView)
                    swaps.append(SwapConstraints(old:ancestorConstraint, new:replacementConstraint, owner:ancestor!))
                }
            }
            ancestor = ancestor?.superview
        }
        newView.tag = tag
        newView.autoresizingMask = autoresizingMask
        newView.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        self.superview?.insertSubview(newView, aboveSubview: self)
        self.removeFromSuperview()
        for (old,new,owner) in swaps {
            owner.addConstraint(new)
            owner.removeConstraint(old)
        }
        return newView
    }
}

class ReplaceViewController: UIViewController {
    @IBOutlet weak var placeholderView: UIView!
    var hasSwapped = false;
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard false == hasSwapped else {
            return
        }
        let swapInVC = self.storyboard!.instantiateViewController(withIdentifier: "InnerViewController")
        self.addChildViewController(swapInVC)
        placeholderView.replaceWith(swapInVC.view)
        swapInVC.didMove(toParentViewController: self)
        hasSwapped = true
    }
}
