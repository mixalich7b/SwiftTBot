//
//  TBInlineQuery.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 03.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBInlineQuery: TBEntity {
    public var id: String = ""
    public var from: TBUser = TBUndefinedUser()
    public var location: TBLocation?
    public var text: String = ""
    public var offset: String = ""
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["id"]
        
        from <- map["from"]
        location <- map["location"]
        text <- map["query"]
        offset <- map["offset"]
    }
}
