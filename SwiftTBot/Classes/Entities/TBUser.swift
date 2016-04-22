//
//  TBUser.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBUser: TBEntity {
    var id: Int!
    var firstName: String!
    var lastName: String?
    var username: String?
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        id <- map["id"]
        
        username <- map["username"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
    }
}
