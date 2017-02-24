//
//  TBInlineQueryResult.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 03.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBInlineQueryResult: TBEntity {
    internal var type: String {get {
        fatalError("Must be overriden")
    } set {
    }}
    internal var id: String = "" // 1-64 Bytes
    internal var inputMessageContent: TBInputMessageContent?
    internal var replyKeyboardMarkup: TBInlineKeyboardMarkup?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- (map["id"], TBLimitedLengthTextTransform(maxLength: 64))
        type <- map["type"]
        inputMessageContent <- map["input_message_content"]
        replyKeyboardMarkup <- map["reply_markup"]
    }
    
    convenience internal init(id: String) {
        self.init()
        self.id = id
    }
}
