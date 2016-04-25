//
//  TBReplyKeyboardHide.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 26.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBReplyKeyboardHide: TBEntity, TBReplyMarkupProtocol {
    public var hideKeyboard: Bool = true
    public var selective: Bool?
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        hideKeyboard <- map["hide_keyboard"]
        selective <- map["selective"]
    }
}
