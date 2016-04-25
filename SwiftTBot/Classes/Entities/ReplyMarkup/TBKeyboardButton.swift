//
//  TBKeyboardButton.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBKeyboardButton: TBEntity {
    public var text: String!
    public var requestContact: Bool?
    public var requestLocation: Bool?
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        text <- map["text"]
        requestContact <- map["request_contact"]
        requestLocation <- map["request_location"]
    }
}
