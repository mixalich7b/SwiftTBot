//
//  TBInlineKeyboardMarkup.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 26.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBInlineKeyboardMarkup: TBEntity, TBReplyMarkupProtocol {
    public var keyboard: [[TBInlineKeyboardButton]]!
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        keyboard <- map["inline_keyboard"]
    }
}
