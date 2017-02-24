//
//  TBError.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Foundation

public enum TBError: Error {
    case badRequest
    case networkError(response: URLResponse?, error: Error?)
    case wrongResponseData(responseData: Data, response: URLResponse?, error: Error?)
    case protocolError(description: String?)
    case responseParsingError(responseDictionary: Dictionary<String, Any>, response: URLResponse?, error: Error?)
}

extension TBError: CustomStringConvertible {
    public var description: String { get {
        switch self {
            case .badRequest: return "BadRequest"
            case .networkError(_, let error): return "Network error: \(error?.localizedDescription)"
            case .wrongResponseData(let responseData, _, _): return "Wrong response: \(NSString(data: responseData, encoding: String.Encoding.utf8.rawValue))"
            case .protocolError(let description): return "Protocol error: \(description)"
            case .responseParsingError(let responseDictionary, _, _): return "Failure on parsing response: \(responseDictionary)"
        }
    } }
}
