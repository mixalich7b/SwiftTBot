//
//  TBMessage.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper
import Foundation

public class TBMessage: TBEntity {
    public var id: Int = -1
    public var from: TBUser?
    public var date: NSDate = NSDate()
    public var chat: TBChat = TBUndefinedChat()
    public var forwardFrom: TBUser?
    public var forwardDate: NSDate?
    public var replyToMessage: TBMessage?
    public var text: String?
    public var entities: [TBMessageEntity]?
    public var caption: String?
    public var contact: TBContact?
    public var location: TBLocation?
    public var venue: TBVenue?
    public var pinnedMessage: TBMessage?
        
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["message_id"]
        from <- map["from"]
        date <- (map["date"], TBUnixTimeTransform())
        chat <- map["chat"]
        forwardFrom <- map["forward_from"]
        forwardDate <- (map["forward_date"], TBUnixTimeTransform())
        replyToMessage <- map["reply_to_message"]
        text <- map["text"]
        entities <- map["entities"]
        caption <- map["caption"]
        contact <- map["contact"]
        location <- map["location"]
        venue <- map["venue"]
        pinnedMessage <- map["pinned_message"]
    }
}
