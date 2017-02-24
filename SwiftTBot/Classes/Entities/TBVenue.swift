//
//  TBVenue.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBVenue: TBEntity {
    public private(set) var location: TBLocation = TBUndefinedLocation()
    public private(set) var title: String = "undefined"
    public private(set) var address: String = "undefined"
    public private(set) var foursquareId: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        location <- map["location"]
        title <- map["title"]
        address <- map["address"]
        foursquareId <- map["foursquare_id"]
    }

}
