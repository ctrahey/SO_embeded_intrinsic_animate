//
//  InnerViewController.swift
//  constraint animation
//
//  Created by Christopher Trahey on 3/2/17.
//  Copyright © 2017 trahey. All rights reserved.
//

import UIKit

class InnerViewController: UIViewController {
    @IBOutlet weak var innerViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var isCollapsed = false {
        didSet {
            let factor:CGFloat = isCollapsed ? 1.5 : 0.66
            let existing = innerViewHeightConstraint.constant
            UIView.animate(withDuration: 1.0) {
                self.innerViewHeightConstraint.constant = existing * factor
                self.view.layoutIfNeeded()
            }
        }
    }

    @IBAction func pokeTapped(_ sender: UIButton) {
        isCollapsed = !isCollapsed
    }
}
