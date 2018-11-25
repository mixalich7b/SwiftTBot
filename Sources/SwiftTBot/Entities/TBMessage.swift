//
//  TBMessage.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Foundation
import ObjectMapper

public final class TBMessage: TBEntity {
    public private(set) var id: Int = -1
    public private(set) var from: TBUser?
    public private(set) var date: Date = Date()
    public private(set) var chat: TBChat = TBUndefinedChat()
    public private(set) var forwardFrom: TBUser?
    public private(set) var forwardDate: Date?
    public private(set) var replyToMessage: TBMessage?
    public private(set) var text: String?
    public private(set) var entities: [TBMessageEntity]?
    public private(set) var caption: String?
    public private(set) var contact: TBContact?
    public private(set) var location: TBLocation?
    public private(set) var venue: TBVenue?
    public private(set) var pinnedMessage: TBMessage?
        
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
