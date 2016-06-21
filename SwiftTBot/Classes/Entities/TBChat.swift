//
//  TBChat.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public enum TBChatType: String {
    case Undefined = "undefined"
    case Private = "private"
    case Group = "group"
    case Supergroup = "supergroup"
    case Channel = "channel"
}

public class TBChat: TBEntity {
    public var id: Int = -1
    public var type: TBChatType = .Undefined
    public var title: String?
    public var username: String?
    public var firstName: String?
    public var lastName: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["id"]
        type <- map["type"]
        
        title <- map["title"]
        username <- map["username"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
    }
}

public class TBUndefinedChat: TBChat {
}
