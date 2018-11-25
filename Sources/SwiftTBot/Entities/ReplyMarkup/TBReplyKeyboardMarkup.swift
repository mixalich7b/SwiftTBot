//
//  TBReplyKeyboardMarkup.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBReplyKeyboardMarkup: TBEntity, TBReplyMarkupProtocol {
    private var keyboard: [[TBKeyboardButton]] = [[]]
    public var resizeKeyboard: Bool?
    public var oneTimeKeyboard: Bool?
    public var selective: Bool?
    
    convenience public init(buttons: [[TBKeyboardButton]]) {
        self.init()
        self.keyboard = buttons
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        keyboard <- map["keyboard"]
        resizeKeyboard <- map["resize_keyboard"]
        oneTimeKeyboard <- map["one_time_keyboard"]
        selective <- map["selective"]
    }
}
