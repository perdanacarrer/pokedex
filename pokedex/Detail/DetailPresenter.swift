//
//  DetailPresenter.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation

class DetailPresenter: BasePresenter {
    weak var view: DetailView?
    var interactor: DetailUseCase?
    var router: DetailWireframe?
    var data: [String : Any]?
    private var id: String?
    private var imageDetail: String?
    private var name: String?
    private var type:[String] = []
    private var subTypes:[String] = []
    private var HP: String?
    private var typeHP: String?
    private var superText: String?
    private var superSub: String?
    private var flavorText: String?
    var dataCount: Int?
    private var ids:[String] = []
    private var names:[String] = []
    private var imageURLs:[String] = []
    private var tempNames:[String] = []
    private var tempImageURLs:[String] = []
    var originalAssetListData: PokeListModel?
}

extension DetailPresenter: DetailPresentation {
    
    func viewDidLoad() {
        setupData()
        view?.showActivityIndicator()
        getPokeDetail()
        getPokedexList()
    }
    
    func setupData() {
        if let data = data {
            if let ids = data["id"] as? String {
                id = ids
            }
        }
    }
    
    func getPokeDetail() {
        interactor?.getPokeDetail(id: id ?? "")
    }
    
    func getPokedexList() {
        interactor?.getPokedexList()
    }
    
    func goToDetail(id: String) {
        var data = [String: Any]()
        data["id"] = id
        router?.navigateToDetail(data: data)
    }
}

extension DetailPresenter: DetailInteractorOutput {
    func successGetPokedexList(data: [[String:Any]]) {
        view?.hideActivityIndicator()
        names.removeAll()
        imageURLs.removeAll()
        ids.removeAll()
        for datas in data {
            let idk = datas["id"] as! String
            if idk != id {
                ids.append(datas["id"] as! String)
                names.append(datas["name"] as! String)
                let images = datas["images"] as! [String:Any]
                imageURLs.append(images["small"] as! String)
            }
        }
        originalAssetListData = PokeListModel(displayName: names, smallImage: imageURLs, id: ids)
        dataCount = ids.count
        view?.reloadData()
    }
    
    func failGetPokedexList(errorMessage: String) {
        view?.hideActivityIndicator()
        view?.showToast(errorMessage)
    }
    
    func successGetPokeDetail(data: [String:Any]) {
        name = "\(data["name"] as! String)"
        HP = "\(data["hp"] as! String)"
        superText = "\(data["supertype"] as! String)"
        flavorText = data["flavorText"] as? String
        let images = data["images"] as! [String:Any]
        imageDetail = images["large"] as? String
        let tipes = data["types"] as! [String]
        let subTipes = data["subtypes"] as! [String]
        for tipe in tipes {
            type.append(tipe)
        }
        for subTipe in subTipes {
            subTypes.append(subTipe)
        }
        let joinedType = type.joined(separator: ", ")
        let joinedSub = subTypes.joined(separator: ", ")
        typeHP = "\(joinedType) (HP \(HP!))"
        superSub = "\(superText!) - \(joinedSub)"
        view?.setDetail(name: name ?? "-", imageDetail: imageDetail ?? "-", typeHP: typeHP ?? "-", superSub: superSub ?? "-", flavorText: flavorText ?? "-")
    }
    
    func failGetPokeDetail(errorMessage: String) {
        view?.showToast(errorMessage)
    }
}

