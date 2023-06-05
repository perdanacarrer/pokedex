//
//  ResponseModel.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation

public protocol GenericConversion {
    associatedtype T
    func convertFrom(_ value: Codable) -> T
}

extension String: GenericConversion {
    
    public typealias T = Codable
    public func convertFrom(_ value: Codable) -> T {
        return value
    }
}

public class ResponseModel<T: Decodable>: Decodable {
    public var success: Bool?
    public var code: Int?
    public var errorCredential: Bool?
    public var message: String?
    public var data: T?
    
    enum CodingKeys: String, CodingKey {
        case errorCredential = "error_credential"
        case success
        case code
        case message
        case data
    }
    
    public init(data: T?) {
        self.data = data
    }
    
    public init(message: String, code: Int, errorCredential: Bool) {
        self.message = message
        self.code = code
        self.errorCredential = errorCredential
    }
}
