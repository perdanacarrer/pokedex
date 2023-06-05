//
//  HomePresenter.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation
import RxSwift
import RxCocoa

class HomePresenter: BasePresenter {
    weak var view: HomeView?
    var interactor: HomeUseCase?
    var router: HomeWireframe?
    var data: [String : Any]?
    var dataCount: Int?
    private var ids:[String] = []
    private var names:[String] = []
    private var imageURLs:[String] = []
    private var tempNames:[String] = []
    private var tempImageURLs:[String] = []
    var originalAssetListData: PokeListModel?
    var filteredData: PokeListModel?
    private func resetFilteredData() {
        filteredData = originalAssetListData
    }
    private let searchSubject = PublishSubject<String>()
    fileprivate let disposeBag = DisposeBag()
}

extension HomePresenter: HomePresentation {
    
    func viewDidLoad() {
        view?.showActivityIndicator()
        getPokedexList()
    }
    
    func getPokedexList() {
        interactor?.getPokedexList()
    }
    
    func goToDetail(id: String) {
        var data = [String: Any]()
        data["id"] = id
        router?.navigateToDetail(data: data)
    }
    
    func bindSearchText() {
        view?.setSearchTextObservable()
            .subscribe(onNext: { [weak self] searchText in
                self?.onSearchPoke(keyword: searchText)
            })
            .disposed(by: disposeBag)
    }
    
    func onSearchPoke(keyword: String) {
        if keyword.count > 0 {
            let indexes = originalAssetListData?.displayName?.filtered(keyword)
            if indexes?.count ?? 0 > 0 {
                tempNames.removeAll()
                tempImageURLs.removeAll()
                for i in indexes! {
                    tempNames.append(names[i])
                    tempImageURLs.append(imageURLs[i])
                }
                dataCount = tempNames.count
                filteredData = PokeListModel(displayName: tempNames, smallImage: tempImageURLs)
            }
            view?.reloadData()
        } else {
            getPokedexList()
        }
    }
}

extension HomePresenter: HomeInteractorOutput {
    func successGetPokedexList(data: [[String:Any]]) {
        view?.hideActivityIndicator()
        names.removeAll()
        imageURLs.removeAll()
        ids.removeAll()
        for datas in data {
            ids.append(datas["id"] as! String)
            names.append(datas["name"] as! String)
            let images = datas["images"] as! [String:Any]
            imageURLs.append(images["small"] as! String)
        }
        originalAssetListData = PokeListModel(displayName: names, smallImage: imageURLs, id: ids)
        resetFilteredData()
        dataCount = ids.count
        view?.reloadData()
    }
    
    func failGetPokedexList(errorMessage: String) {
        view?.hideActivityIndicator()
        view?.showToast(errorMessage)
    }
}

extension Array where Element: Equatable {

    func filtered(_ value :  Element) -> [Int] {
        return self.indices.filter {self[$0] == value}
    }

}
