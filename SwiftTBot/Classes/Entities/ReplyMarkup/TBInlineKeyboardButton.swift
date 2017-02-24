//
//  TBInlineKeyboardButton.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBInlineKeyboardButton: TBEntity {
    private var text: String = ""
    private var url: String?
    private var callbackData: String? // 1-64 bytes
    private var switchInlineQuery: String?
    
    convenience public init(text: String) {
        self.init()
        self.text = text
    }
    
    convenience public init(text: String, url: String?) {
        self.init()
        self.text = text
        self.url = url
    }
    
    convenience public init(text: String, callbackData: String?) {
        self.init()
        self.text = text
        self.callbackData = callbackData
    }
    
    convenience public init(text: String, switchInlineQuery: String?) {
        self.init()
        self.text = text
        self.switchInlineQuery = switchInlineQuery
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        text <- map["text"]
        url <- map["url"]
        callbackData <- (map["callback_data"], TBLimitedLengthTextTransform(maxLength: 64))
        switchInlineQuery <- map["switch_inline_query"]
    }
}
