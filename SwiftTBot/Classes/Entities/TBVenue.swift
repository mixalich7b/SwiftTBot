//
//  TBVenue.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBVenue: TBEntity {
    public var location: TBLocation = TBUndefinedLocation()
    public var title: String = "undefined"
    public var address: String = "undefined"
    public var foursquareId: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        location <- map["location"]
        title <- map["title"]
        address <- map["address"]
        foursquareId <- map["foursquare_id"]
    }

}
