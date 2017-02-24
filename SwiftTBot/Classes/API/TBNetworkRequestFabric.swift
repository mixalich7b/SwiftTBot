//
//  TBNetworkRequestFabric.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

internal final class TBNetworkRequestFabric {
    private static let baseUrl = "https://api.telegram.org/bot"
    
    internal class func networkRequestWithRequest<ResponseEntity: TBEntity>(_ request: TBRequest<ResponseEntity>, token: String) -> URLRequest? {
        let URLString = "\(self.baseUrl)\(token)/\(request.getMethod())"
        guard let URL = URL(string: URLString) else {
            return Optional.none
        }
        guard let JSONString = request.toJSONString() else {
            return Optional.none
        }
        let URLRequest = NSMutableURLRequest(url: URL)
        URLRequest.httpMethod = "POST"
        URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLRequest.httpBody = JSONString.data(using: String.Encoding.utf8)
        return URLRequest.copy() as? Foundation.URLRequest
    }
}
