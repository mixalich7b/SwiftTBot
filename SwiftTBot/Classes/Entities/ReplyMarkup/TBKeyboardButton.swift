//
//  TBKeyboardButton.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBKeyboardButton: TBEntity {
    public var text: String = ""
    public var requestContact: Bool?
    public var requestLocation: Bool?
    
    convenience public init(text: String) {
        self.init()
        self.text = text
    }
    
    convenience public init(text: String, requestContact: Bool?) {
        self.init()
        self.text = text
        self.requestContact = requestContact
    }
    
    convenience public init(text: String, requestLocation: Bool?) {
        self.init()
        self.text = text
        self.requestLocation = requestLocation
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        text <- map["text"]
        requestContact <- map["request_contact"]
        requestLocation <- map["request_location"]
    }
}
