//
//  TBNetworkRequestFabric.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper
import Foundation

internal final class TBNetworkRequestFabric {
    private static let baseUrl = "https://api.telegram.org/bot"
    
    internal class func networkRequestWithRequest<ResponseEntity: TBEntity>(request: TBRequest<ResponseEntity>, token: String) -> URLRequest? {
        let URLString = "\(self.baseUrl)\(token)/\(request.getMethod())"
        guard let URL = URL(string: URLString) else {
            return Optional.none
        }
        guard let JSONString = request.toJSONString() else {
            return Optional.none
        }
        var urlRequest = URLRequest(url: URL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = JSONString.data(using: String.Encoding.utf8)
        return urlRequest
    }
}
