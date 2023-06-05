//
//  ServiceListener.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation

public enum InvalidationType {
    case expired(message: String)
    case refresh(message: String)
}

public struct ServiceListener<T: Codable> {
    
    public var onSuccess: (ResponseModel<T>) -> Void
    public var onFailed: (String) -> Void
    public var onInvalidCredential: ((InvalidationType) -> Void)?
    public var onOtherFailure: ((Error) -> Void)?
    
    public init(onSuccess: @escaping (ResponseModel<T>) -> Void, onFailed: @escaping (String) -> Void, onInvalidCredential: ((InvalidationType) -> Void)? = nil, onOtherFailure: ((Error) -> Void)? = nil) {
        self.onSuccess = onSuccess
        self.onFailed = onFailed
        self.onInvalidCredential = onInvalidCredential
        self.onOtherFailure = onOtherFailure
    }
}
