//
//  Model.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation

public struct EmptyModel: Codable {
    
}

public struct PokeListModel: Codable {
    public var displayName, smallImage, id: [String]?


    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case smallImage, id
    }
    
    public init(displayName: [String]? = nil, smallImage: [String]? = nil, id: [String]? = nil) {
        self.displayName = displayName
        self.smallImage = smallImage
        self.id = id
    }
}

public struct PokeDetailModel: Codable {
    public var displayName, superType, hp, flavorText, largeImage, id: String?
    public var types, subTypes: [String]?


    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case superType, subTypes, types, hp, flavorText, largeImage, id
    }
    
    public init(displayName: String? = nil, superType: String? = nil, subTypes: [String]? = nil, types: [String]? = nil, hp: String? = nil, flavorText: String? = nil, largeImage: String? = nil, id: String? = nil) {
        self.displayName = displayName
        self.superType = superType
        self.subTypes = subTypes
        self.types = types
        self.hp = hp
        self.flavorText = flavorText
        self.largeImage = largeImage
        self.id = id
    }
}
