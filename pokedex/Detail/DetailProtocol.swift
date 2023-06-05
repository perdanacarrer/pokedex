//
//  DetailProtocol.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation
import UIKit

// MARK: - ViewController
protocol DetailView: AnyObject {
    var presenter: DetailPresentation? { get set }
    func showToast(_ text: String)
    func reloadData()
    func setDetail(name: String, imageDetail: String, typeHP: String, superSub: String, flavorText: String)
    func showActivityIndicator()
    func hideActivityIndicator()
}

// MARK: - Interactor
protocol DetailUseCase: AnyObject {
    var presenter: DetailInteractorOutput? { get set }
    func getPokedexList()
    func getPokeDetail(id: String)
}

// MARK: - Router
protocol DetailWireframe: AnyObject {
    func createModule(data: [String:Any]?) -> BaseViewController
    func navigateToDetail(data: [String : Any])
}

// MARK: - Presenter
protocol DetailPresentation: AnyObject {
    var view: DetailView? { get set }
    var interactor: DetailUseCase? { get set }
    var router: DetailWireframe? { get set }
    var data: [String: Any]? { get set }
    var dataCount: Int? { get set }
    var originalAssetListData: PokeListModel? { get set }
    func viewDidLoad()
    func setupData()
    func getPokeDetail()
    func getPokedexList()
    func goToDetail(id: String)
}

protocol DetailInteractorOutput: AnyObject {
    func successGetPokedexList(data: [[String:Any]])
    func failGetPokedexList(errorMessage: String)
    func successGetPokeDetail(data: [String:Any])
    func failGetPokeDetail(errorMessage: String)
}

