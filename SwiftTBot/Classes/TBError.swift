//
//  TBError.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Foundation

public enum TBError: ErrorProtocol {
    case BadRequest
    case NetworkError(response: URLResponse?, error: NSError?)
    case WrongResponseData(responseData: Data, response: URLResponse?, error: NSError?)
    case ProtocolError(description: String?)
    case ResponseParsingError(responseDictionary: Dictionary<String, AnyObject>, response: URLResponse?, error: NSError?)
}

extension TBError: CustomStringConvertible {
    public var description: String { get {
        switch self {
            case .BadRequest: return "BadRequest"
            case .NetworkError(_, let error): return "Network error: \(error?.localizedDescription)"
            case .WrongResponseData(let responseData, _, _): return "Wrong response: \(NSString(data: responseData, encoding: String.Encoding.utf8.rawValue))"
            case ProtocolError(let description): return "Protocol error: \(description)"
            case ResponseParsingError(let responseDictionary, _, _): return "Failure on parsing response: \(responseDictionary)"
        }
    } }
}
