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
    public var url: String?
    public var callbackData: String? // 1-64 bytes
    public var switchInlineQuery: String?
    
    convenience public init(text: String) {
        self.init()
        self.text = text
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        text <- map["text"]
        url <- map["url"]
        callbackData <- (map["callback_data"], TBLimitedLengthTextTransform(maxLength: 64))
        switchInlineQuery <- map["switch_inline_query"]
    }
}
