//
//  File.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation

public struct Config {
    
    public enum Domain: String {
        case Pokedex = "https://api.pokemontcg.io/v2/cards"

        func callAsFunction() -> String {
            return self.rawValue
        }
    }
    
    public static var enableSSLPinning: Bool = true
    public static let LocaleIdentifier: String = "id_ID"
    
    public static var BaseURL = Domain.Pokedex()

}
