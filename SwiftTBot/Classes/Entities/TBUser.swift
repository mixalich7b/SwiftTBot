//
//  TBUser.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBUser: TBEntity {
    public var id: Int!
    public var firstName: String!
    public var lastName: String?
    public var username: String?
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        id <- map["id"]
        
        username <- map["username"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
    }
}
