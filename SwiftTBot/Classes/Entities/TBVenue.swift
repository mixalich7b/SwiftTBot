//
//  TBVenue.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBVenue: TBEntity {
    public var location: TBLocation!
    public var title: String!
    public var address: String!
    public var foursquareId: String?
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        location <- map["location"]
        title <- map["title"]
        address <- map["address"]
        foursquareId <- map["foursquare_id"]
    }

}
