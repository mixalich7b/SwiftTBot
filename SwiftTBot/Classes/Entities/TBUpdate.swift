//
//  TBUpdate.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

internal final class TBUpdate: TBEntity {
    internal var id: Int = -1
    internal var message: TBMessage?
    internal var inlineQuery: TBInlineQuery?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["update_id"]
        message <- map["message"]
        inlineQuery <- map["inline_query"]
    }
}
