//
//  AppWireframe.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import UIKit

public class AppWireframe {
    
    public init() {}

    private func changeRootViewController(vc: UIViewController) {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        let trans = CATransition()
        trans.type = CATransitionType.push
        trans.subtype = CATransitionSubtype.fromRight
        window?.layer.add(trans, forKey: kCATransition)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

extension AppWireframe: NavigationDelegate {
    
    public func navigateToPage(_ destination: String, from: UIViewController) {
        let classRouterType = NSClassFromString(destination) as? BaseRouter.Type
   
        if let vc: BaseViewController = classRouterType?.init().createModule() {
            changePage(dest: vc, from: from)
        } else {
            handlePageNotFound()
        }
    }
    
    public func navigateToPageWithArgs(_ destination: String, from: UIViewController, data: [String : Any]) {
        let classRouterType = NSClassFromString(destination) as? BaseRouter.Type
        if let vc: BaseViewController = classRouterType?.init().createModule(data: data) {
            changePage(dest: vc, from: from)
        } else {
            handlePageNotFound()
        }
    }
    
    public func presentPage(_ destination: String, from: UIViewController, modalPresentationStyle: UIModalPresentationStyle) {
        let classRouterType = NSClassFromString(destination) as? BaseRouter.Type
   
        if let vc: BaseViewController = classRouterType?.init().createModule() {
            self.presentView(dest: UINavigationController(rootViewController: vc), from: from, modalPresentationStyle: modalPresentationStyle)
        } else {
            handlePageNotFound()
        }
    }
    
    public func presentPageWithNoAnimation(_ destination: String, from: UIViewController, modalPresentationStyle: UIModalPresentationStyle) {
        let classRouterType = NSClassFromString(destination) as? BaseRouter.Type
   
        if let vc: BaseViewController = classRouterType?.init().createModule() {
            self.presentView(dest: UINavigationController(rootViewController: vc), from: from, modalPresentationStyle: modalPresentationStyle, animated: false)
        } else {
            handlePageNotFound()
        }
    }
    
    public func presentPageWithArgs(_ destination: String, from: UIViewController, modalPresentationStyle: UIModalPresentationStyle, data: [String: Any]) {
        let classRouterType = NSClassFromString(destination) as? BaseRouter.Type
   
        if let vc: BaseViewController = classRouterType?.init().createModule(data: data) {
            self.presentView(dest: UINavigationController(rootViewController: vc), from: from, modalPresentationStyle: modalPresentationStyle)
        } else {
            handlePageNotFound()
        }
    }
    
    /// This function is called to change root navigation controller.
    /// `Example: from Splash to Home.`
    /// - Parameters:
    ///  - root: Root View you want to set
    ///  - child:
    public func changeRoot(_ root: String, child: String?) {
        let classRouterType = NSClassFromString(root) as? BaseRouter.Type
        if let rootVC: BaseViewController = classRouterType?.init().createModule() {
            let nav = UINavigationController(rootViewController: rootVC)
            changeRootViewController(vc: nav)
            var vcStack: [BaseViewController] = [rootVC]

            if let child = child, let childClassRouterType = NSClassFromString(child) as? BaseRouter.Type {
                let vc = childClassRouterType.init().createModule()
                vcStack.append(vc)
            }
            nav.setViewControllers(vcStack, animated: true)
        } else if let tabBarType = NSClassFromString(root) as? UITabBarController.Type {
            changeRootViewController(vc: tabBarType.init())
        } else {
            handlePageNotFound()
        }
    }

    public func popToRootViewController(animated: Bool) {
        if let tabBar = getRootViewController() as? UITabBarController {
            guard let navigationController = tabBar.selectedViewController as? UINavigationController, let childRootViewController = navigationController.viewControllers.first else { return }
            dismissAllViewController(childRootViewController, animated: animated)
        } else if let navigationController = getRootViewController() as? UINavigationController {
            dismissAllViewController(navigationController, animated: animated)
        } else {
            let rootViewController = getRootViewController()
            rootViewController?.dismiss(animated: animated)
        }
    }
    
    public func popViewController(_ vc: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let navigationController = vc.navigationController else {
            vc.dismiss(animated: animated, completion: completion)
            return
        }
        
        if navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: animated)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let completion {
                    completion()
                }
            }
        } else {
            navigationController.dismiss(animated: animated, completion: completion)
        }
    }
    
    private func getRootViewController() -> UIViewController? {
        return UIApplication.shared.delegate?.window??.rootViewController
    }
    
    private func dismissAllViewController(_ vc: UIViewController, animated: Bool) {
        if vc.presentedViewController != nil {
            vc.dismiss(animated: animated)
        }
        
        if let navigationStackCount = vc.navigationController?.viewControllers.count, navigationStackCount > 1 {
            vc.navigationController?.popToRootViewController(animated: animated)
        }
    }

    private func changePage(dest: UIViewController, from: UIViewController, hideBottomBar: Bool = true) {
        dest.hidesBottomBarWhenPushed = hideBottomBar
        from.navigationController?.pushViewController(dest, animated: true)
    }
    
    private func presentView(dest: UIViewController, from: UIViewController, modalPresentationStyle: UIModalPresentationStyle = .fullScreen, animated: Bool = true) {
        dest.modalPresentationStyle = modalPresentationStyle
        from.present(dest, animated: animated)
    }
    
    private func handlePageNotFound() {
        // TODO: create handler when ViewController not found in project
        print("not found")
    }

}

