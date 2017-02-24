//
//  TBContact.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBContact: TBEntity {
    public private(set) var phoneNumber: String = ""
    public private(set) var firstName: String = ""
    public private(set) var lastName: String?
    public private(set) var userId: Int?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        phoneNumber <- map["phone_number"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        userId <- map["user_id"]
    }
}
