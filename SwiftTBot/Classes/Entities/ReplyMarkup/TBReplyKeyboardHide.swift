//
//  TBReplyKeyboardHide.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 26.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBReplyKeyboardHide: TBEntity, TBReplyMarkupProtocol {
    private var hideKeyboard: Bool = true
    public var selective: Bool?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        hideKeyboard <- map["hide_keyboard"]
        selective <- map["selective"]
    }
}
