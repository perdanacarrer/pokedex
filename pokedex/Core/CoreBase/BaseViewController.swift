//
//  BaseViewController.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import UIKit

open class BaseViewController: BaseLayout {
            
    //Override this variable before super.viewWillAppear()
    //isTabSwipeEnabled = Flag to override tab swipe
    //isSwipeBackEnabled = Flag to override swipe / back swipe gesture
    public var isTabSwipeEnabled: Bool = false
    public var isSwipeBackEnabled: Bool = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        onViewLoaded()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        onViewWillAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = isSwipeBackEnabled
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func onViewLoaded() { }
    
    func onViewWillAppear() {}
}
