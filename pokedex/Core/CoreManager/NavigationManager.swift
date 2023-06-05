//
//  NavigationManager.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation
import UIKit

// String Rules
// Example:
// public static var sampleRouter =  "ModuleName.ClassRouterName"

public struct NavigationDestination {
    public struct pokedex {
        public static var home = "\(pokedex.self).HomeRouter"
        public static var detail = "\(pokedex.self).DetailRouter"
    }
}

public protocol NavigationDelegate {
    func navigateToPage(_ destination: String, from: UIViewController)
    func navigateToPageWithArgs(_ destination: String, from: UIViewController, data: [String : Any])
    func changeRoot(_ root: String, child: String?)
    func presentPage(_ destination: String, from: UIViewController, modalPresentationStyle: UIModalPresentationStyle)
    func presentPageWithNoAnimation(_ destination: String, from: UIViewController, modalPresentationStyle: UIModalPresentationStyle)
    func presentPageWithArgs(_ destination: String, from: UIViewController, modalPresentationStyle: UIModalPresentationStyle, data: [String: Any])
    func popViewController(_ vc: UIViewController, animated: Bool, completion: (() -> Void)?)
    func popToRootViewController(animated: Bool)
}

public class NavigationManager {
    public static var shared = NavigationManager()
    public var navDelegate: NavigationDelegate?
}

