//
//  CodableModelTests.swift
//  pokedexTests
//
//  Created by oscar perdana on 04/06/23.
//

import XCTest
@testable import pokedex

class CodableModelTests: XCTestCase {
    
    func testEmptyModelCoding() throws {
        let emptyModel = EmptyModel()
        
        let encodedData = try JSONEncoder().encode(emptyModel)
        let decodedModel = try JSONDecoder().decode(EmptyModel.self, from: encodedData)
        
        XCTAssertEqual(emptyModel, decodedModel)
    }
    
    func testPokeListModelCoding() throws {
        let pokeListModel = PokeListModel(displayName: ["Pikachu"], smallImage: ["pikachu.png"], id: ["001"])
        
        let encodedData = try JSONEncoder().encode(pokeListModel)
        let decodedModel = try JSONDecoder().decode(PokeListModel.self, from: encodedData)
        
        XCTAssertEqual(pokeListModel, decodedModel)
    }
    
    func testPokeDetailModelCoding() throws {
        let pokeDetailModel = PokeDetailModel(displayName: "Pikachu", superType: "Electric", subTypes: ["Basic"], types: ["Electric"], hp: "60", flavorText: "Pikachu is an electric Pokémon.", largeImage: "pikachu_large.png", id: "001")
        
        let encodedData = try JSONEncoder().encode(pokeDetailModel)
        let decodedModel = try JSONDecoder().decode(PokeDetailModel.self, from: encodedData)
        
        XCTAssertEqual(pokeDetailModel, decodedModel)
    }
    
}

extension EmptyModel: Equatable {
    public static func == (lhs: EmptyModel, rhs: EmptyModel) -> Bool {
        // EmptyModel has no properties, so we consider all instances equal
        return true
    }
}

extension PokeListModel: Equatable {
    public static func == (lhs: PokeListModel, rhs: PokeListModel) -> Bool {
        return lhs.displayName == rhs.displayName &&
            lhs.smallImage == rhs.smallImage &&
            lhs.id == rhs.id
    }
}

extension PokeDetailModel: Equatable {
    public static func == (lhs: PokeDetailModel, rhs: PokeDetailModel) -> Bool {
        return lhs.displayName == rhs.displayName &&
            lhs.superType == rhs.superType &&
            lhs.hp == rhs.hp &&
            lhs.flavorText == rhs.flavorText &&
            lhs.largeImage == rhs.largeImage &&
            lhs.id == rhs.id &&
            lhs.types == rhs.types &&
            lhs.subTypes == rhs.subTypes
    }
}

