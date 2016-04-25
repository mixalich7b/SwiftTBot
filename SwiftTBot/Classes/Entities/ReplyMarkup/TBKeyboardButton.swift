//
//  TBKeyboardButton.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBKeyboardButton: TBEntity {
    public var text: String! = ""
    public var requestContact: Bool?
    public var requestLocation: Bool?
    
    public convenience init(text: String) {
        self.init(JSON: [:])!
        self.text = text
    }
    
    public convenience init(text: String, requestContact: Bool?) {
        self.init(JSON: [:])!
        self.text = text
        self.requestContact = requestContact
    }
    
    public convenience init(text: String, requestLocation: Bool?) {
        self.init(JSON: [:])!
        self.text = text
        self.requestLocation = requestLocation
    }
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        text <- map["text"]
        requestContact <- map["request_contact"]
        requestLocation <- map["request_location"]
    }
}
