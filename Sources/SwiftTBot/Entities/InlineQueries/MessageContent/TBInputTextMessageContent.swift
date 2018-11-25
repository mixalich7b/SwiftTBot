//
//  TBInputTextMessageContent.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 03.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBInputTextMessageContent: TBInputMessageContent {
    private var messageText: String = "" // 1-4096 characters
    private var parseMode: TBSendMessageParseMode?
    private var disableWebPagePreview: Bool?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        messageText <- (map["message_text"], TBLimitedLengthTextTransform(maxLength: 4096))
        parseMode <- map["parse_mode"]
        disableWebPagePreview <- map["disable_web_page_preview"]
    }
        
    convenience public init(messageText: String, parseMode: TBSendMessageParseMode = .None) {
        self.init()
        self.messageText = messageText
        self.parseMode = parseMode
    }
}
