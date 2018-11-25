//
//  TBInlineQuery.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 03.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBInlineQuery: TBEntity {
    public internal(set) var id: String = ""
    public internal(set) var from: TBUser = TBUndefinedUser()
    public internal(set) var location: TBLocation?
    public internal(set) var text: String = ""
    public internal(set) var offset: String = ""
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["id"]
        
        from <- map["from"]
        location <- map["location"]
        text <- map["query"]
        offset <- map["offset"]
    }
}
