//
//  TBLocation.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBLocation: TBEntity {
    public var longitude: Float!
    public var latitude: Float!
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        longitude <- map["longitude"]
        latitude <- map["latitude"]
    }
}
