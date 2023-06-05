//
//  DetailInteractor.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation
import Alamofire

class DetailInteractor: BaseInteractor {
    weak var presenter: DetailInteractorOutput?
}

extension DetailInteractor: DetailUseCase {
    
    func getPokedexList() {
        if !ReachabilityHelper().isConnectedToNetwork() {
            self.presenter?.failGetPokedexList(errorMessage: "Failed get Pokedex")
            return
        } else {
            Alamofire.request(Config.BaseURL, method : .get, parameters: nil).responseJSON { [weak self] response in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil {
                        let data = response.result.value as? [String:Any]
                        let statusCode = response.response?.statusCode
                        let result = data!["data"] as! [[String:Any]]
                        if statusCode == 200 {
                            self?.presenter?.successGetPokedexList(data: result)
                        } else {
                            let message = data!["message"]
                            DispatchQueue.main.async {
                                self?.presenter?.failGetPokedexList(errorMessage: message as? String ?? "Failed get Pokedex")
                            }
                        }
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.presenter?.failGetPokedexList(errorMessage: "Failed get Pokedex")
                    }
                }
            }
        }
    }
    
    func getPokeDetail(id: String) {
        if !ReachabilityHelper().isConnectedToNetwork() {
            self.presenter?.failGetPokeDetail(errorMessage: "Failed get Pokemon detail")
            return
        } else {
            Alamofire.request(Config.BaseURL+"/"+id, method : .get, parameters: nil).responseJSON { [weak self] response in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil {
                        let data = response.result.value as? [String:Any]
                        let statusCode = response.response?.statusCode
                        let result = data!["data"] as! [String:Any]
                        if statusCode == 200 {
                            self?.presenter?.successGetPokeDetail(data: result)
                        } else {
                            let message = data!["message"]
                            DispatchQueue.main.async {
                                self?.presenter?.failGetPokeDetail(errorMessage: message as? String ?? "Failed get Pokemon detail")
                            }
                        }
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.presenter?.failGetPokeDetail(errorMessage: "Failed get Pokemon detail")
                    }
                }
            }
        }
    }
}

