//
//  APIConfiguration.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation
import Alamofire

enum ContentType: String {
    case json = "application/json"
    case multipart = "multipart/form-data"
}

public protocol APIConfiguration: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var multipartFormData: MultipartFormData? { get }
    var parameterEncoding: ParameterEncoding { get }
}

public extension APIConfiguration {
    
    /// Set Default Value for APIConfiguration
    
    var baseURL: String {
        Config.BaseURL
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters? {
        nil
    }
    
    var multipartFormData: MultipartFormData? {
        nil
    }
    
    var parameterEncoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    // MARK: utility
    
    func asURLRequest() throws -> URLRequest {
        var base: String = ""
        base = Config.BaseURL
        
        let url = base + path
        var urlRequest = URLRequest(url: URL(string: base + path) ?? URL(string: base)!)
        // MARK: - Cleaned URI if success
        if let uri = url.getCleanedURL() {
            urlRequest =  URLRequest(url: uri)
        }
        
        urlRequest.httpMethod = method.rawValue
        
        return try parameterEncoding.encode(urlRequest, with: parameters)
    }
}
