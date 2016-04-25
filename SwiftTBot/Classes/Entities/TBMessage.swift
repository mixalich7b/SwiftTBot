//
//  TBMessage.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBMessage: TBEntity {
    public var id: Int!
    public var from: TBUser?
    public var date: NSDate!
    public var chat: TBChat!
    public var forwardFrom: TBUser?
    public var forwardDate: NSDate?
    public var replyToMessage: TBMessage?
    public var text: String?
        
    override public func mapping(map: Map) {
        super.mapping(map)
        
        id <- map["message_id"]
        from <- map["from"]
        date <- (map["date"], TBUnixTimeTransform())
        chat <- map["chat"]
        forwardFrom <- map["forward_from"]
        forwardDate <- (map["forward_date"], TBUnixTimeTransform())
        replyToMessage <- map["reply_to_message"]
        text <- map["text"]
    }
}
