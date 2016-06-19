//
//  EditSplitViewController.swift
//  Brain TV
//
//  Created by Lucas Bonin on 6/18/16.
//  Copyright © 2016 Lucas Bonin. All rights reserved.
//

import UIKit

class EditSplitViewController: UISplitViewController {
    
    
    private var preferDetailViewControllerOnNextFocusUpdate = false
    
    override var preferredFocusedView: UIView? {
        let preferredFocusedView: UIView?
        
        if preferDetailViewControllerOnNextFocusUpdate {
            preferredFocusedView = viewControllers.last?.preferredFocusedView
            preferDetailViewControllerOnNextFocusUpdate = false
        }
        else {
            preferredFocusedView = super.preferredFocusedView
        }
        
        return preferredFocusedView
    }
    
    
    // Muda foco para DetailView
    func updateFocusToDetailViewController() {
        preferDetailViewControllerOnNextFocusUpdate = true
        
        setNeedsFocusUpdate()
        updateFocusIfNeeded()
    }

}
