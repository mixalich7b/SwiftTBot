//
//  TBUser.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBUser: TBEntity {
    public private(set) var id: Int = -1
    public private(set) var firstName: String = ""
    public private(set) var lastName: String?
    public private(set) var username: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["id"]
        
        username <- map["username"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
    }
}

public final class TBUndefinedUser: TBUser {
}
