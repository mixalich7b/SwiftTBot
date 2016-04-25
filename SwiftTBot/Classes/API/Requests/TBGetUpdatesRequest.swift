//
//  TBGetUpdatesRequest.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBGetUpdatesRequest<Res: TBUpdate>: TBRequest<Res> {
    override internal func getMethod() -> String {
        return "getUpdates"
    }
    
    var offset: Int?
    var limit: Int?
    var timeout: Int?
    
    required public init?(JSON: [String : AnyObject]) {
        super.init(JSON: JSON)
    }
    
    public convenience init(offset: Int, limit: Int, timeout: Int) {
        self.init(JSON: [:])!
        self.offset = offset
        self.limit = limit
        self.timeout = timeout
    }
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        offset <- map["offset"]
        limit <- map["limit"]
        timeout <- map["timeout"]
    }
}
