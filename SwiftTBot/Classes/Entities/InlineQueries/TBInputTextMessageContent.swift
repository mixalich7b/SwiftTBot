//
//  TBInputTextMessageContent.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 03.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBInputTextMessageContent: TBEntity, TBInputMessageContentProtocol {
    public var messageText: String = "" // 1-4096 characters
    public var parseMode: TBSendMessageParseMode?
    public var disableWebPagePreview: Bool?
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        messageText <- (map["message_text"], TBLimitedLengthTextTransform(maxLength: 4096))
        parseMode <- map["parse_mode"]
        disableWebPagePreview <- map["disable_web_page_preview"]
    }
    
    override public init() {
        super.init()
    }
    
    required public init?(_ map: Map) {
        super.init(map)
    }
    
    convenience public init(messageText: String, parseMode: TBSendMessageParseMode = .None) {
        self.init()
        self.messageText = messageText
        self.parseMode = parseMode
    }
}
