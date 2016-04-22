//
//  TBMessage.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBMessage: TBEntity {
    var id: Int!
    var chat: TBChat!
    var text: String?
        
    override public func mapping(map: Map) {
        super.mapping(map)
        
        id <- map["message_id"]
        text <- map["text"]
        chat <- map["chat"]
    }
}
