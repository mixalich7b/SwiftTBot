//
//  TBContact.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBContact: TBEntity {
    public var phoneNumber: String = ""
    public var firstName: String = ""
    public var lastName: String?
    public var userId: Int?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        phoneNumber <- map["phone_number"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        userId <- map["user_id"]
    }
}
