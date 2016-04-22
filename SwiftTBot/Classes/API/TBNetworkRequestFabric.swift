//
//  TBNetworkRequestFabric.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBNetworkRequestFabric {
    private static let baseUrl = "https://api.telegram.org/bot"
    
    public class func networkRequestWithRequest(request: TBRequest, token: String) -> NSURLRequest? {
        let URLString = "\(self.baseUrl)\(token)/\(request.getMethod())"
        guard let URL = NSURL(string: URLString) else {
            return Optional.None
        }
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.HTTPMethod = "POST"
        URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLRequest.HTTPBody = request.toJSONString()?.dataUsingEncoding(NSUTF8StringEncoding)
        return URLRequest.copy() as? NSURLRequest
    }
}
