//
//  TBGetUpdatesRequest.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBGetUpdatesRequest: TBRequest<TBUpdate> {
    override internal func getMethod() -> String {
        return "getUpdates"
    }
    
    var offset: Int?
    var limit: Int?
    var timeout: Int?
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        offset <- map["offset"]
        limit <- map["limit"]
        timeout <- map["timeout"]
    }
}
