//
//  TBChat.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public enum TBChatType: String {
    case Private = "private"
    case Group = "group"
    case Supergroup = "supergroup"
    case Channel = "channel"
}

public class TBChat: TBEntity {
    var id: Int!
    var type: TBChatType!
    var username: String?
    var firstName: String?
    var lastName: String?
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        id <- map["id"]
        type <- map["type"]
        
        username <- map["username"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
    }
}
