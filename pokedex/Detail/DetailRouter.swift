//
//  DetailRouter.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import UIKit

public class DetailRouter: BaseRouter {

    weak var viewController : DetailViewController?
    
    public override func createModule(data: [String:Any]?) -> BaseViewController {
        let view: BaseViewController & DetailView = DetailViewController()
        let presenter: DetailPresentation & DetailInteractorOutput = DetailPresenter()
        let interactor: DetailUseCase = DetailInteractor()
        let router: DetailWireframe = self

        view.presenter = presenter
        presenter.data = data
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        viewController = view as? DetailViewController

        return view
    }
}

extension DetailRouter: DetailWireframe {
    func navigateToDetail(data: [String : Any]) {
        guard let viewController = viewController else { return }
        NavigationManager.shared.navDelegate?.navigateToPageWithArgs(NavigationDestination.pokedex.detail, from: viewController, data: data)
    }
}

