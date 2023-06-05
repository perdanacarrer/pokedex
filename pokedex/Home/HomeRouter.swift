//
//  HomeRouter.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import UIKit

public class HomeRouter: BaseRouter {

    weak var viewController : HomeViewController?
    
    public override func createModule(data: [String:Any]?) -> BaseViewController {
        let view: BaseViewController & HomeView = HomeViewController()
        let presenter: HomePresentation & HomeInteractorOutput = HomePresenter()
        let interactor: HomeUseCase = HomeInteractor()
        let router: HomeWireframe = self

        view.presenter = presenter
        presenter.data = data
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        viewController = view as? HomeViewController

        return view
    }
}

extension HomeRouter: HomeWireframe {
    func navigateToDetail(data: [String : Any]) {
        guard let viewController = viewController else { return }
        NavigationManager.shared.navDelegate?.navigateToPageWithArgs(NavigationDestination.pokedex.detail, from: viewController, data: data)
    }
}
