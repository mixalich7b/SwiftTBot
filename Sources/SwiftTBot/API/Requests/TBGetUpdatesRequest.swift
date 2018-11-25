//
//  TBGetUpdatesRequest.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

internal final class TBGetUpdatesRequest<Res: TBUpdate>: TBRequest<Res> {
    override internal func getMethod() -> String {
        return "getUpdates"
    }
    
    private var offset: Int?
    private var limit: Int?
    private var timeout: Int?
    
    convenience internal init(offset: Int, limit: Int, timeout: Int) {
        self.init()
        self.offset = offset
        self.limit = limit
        self.timeout = timeout
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        offset <- map["offset"]
        limit <- map["limit"]
        timeout <- map["timeout"]
    }
}
