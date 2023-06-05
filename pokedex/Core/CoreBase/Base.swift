//
//  BasePresenter.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation

open class BasePresenter {
    
    public init() {}
}

open class BaseInteractor {
    
    public init() {}
}

open class BaseRouter {
 
    required public init() {}
    
    open func createModule(data: [String:Any]? = nil) -> BaseViewController {
        return BaseViewController()
    }
}
