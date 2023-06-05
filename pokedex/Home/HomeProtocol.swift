//
//  HomeProtocol.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation
import UIKit
import RxSwift

// MARK: - ViewController
protocol HomeView: AnyObject {
    var presenter: HomePresentation? { get set }
    func showToast(_ text: String)
    func reloadData()
    func showActivityIndicator()
    func hideActivityIndicator()
    func setSearchTextObservable() -> Observable<String>
}

// MARK: - Interactor
protocol HomeUseCase: AnyObject {
    var presenter: HomeInteractorOutput? { get set }
    func getPokedexList()
}

// MARK: - Router
protocol HomeWireframe: AnyObject {
    func createModule(data: [String:Any]?) -> BaseViewController
    func navigateToDetail(data: [String : Any])
}

// MARK: - Presenter
protocol HomePresentation: AnyObject {
    var view: HomeView? { get set }
    var interactor: HomeUseCase? { get set }
    var router: HomeWireframe? { get set }
    var data: [String: Any]? { get set }
    var dataCount: Int? { get set }
    var originalAssetListData: PokeListModel? { get set }
    var filteredData: PokeListModel? { get set }
    func viewDidLoad()
    func getPokedexList()
    func bindSearchText()
    func onSearchPoke(keyword: String)
    func goToDetail(id: String)
}

protocol HomeInteractorOutput: AnyObject {
    func successGetPokedexList(data: [[String:Any]])
    func failGetPokedexList(errorMessage: String)
}
