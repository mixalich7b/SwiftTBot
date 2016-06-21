//
//  TBUpdate.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBUpdate: TBEntity {
    public var id: Int = -1
    public var message: TBMessage?
    public var inlineQuery: TBInlineQuery?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["update_id"]
        message <- map["message"]
        inlineQuery <- map["inline_query"]
    }
}
