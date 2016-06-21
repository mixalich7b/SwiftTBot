//
//  TBLocation.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBLocation: TBEntity, CustomDebugStringConvertible {
    public var longitude: Float = 0
    public var latitude: Float = 0
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        longitude <- map["longitude"]
        latitude <- map["latitude"]
    }
    
    public var debugDescription: String { get {
        return "lon: \(self.longitude), lat: \(self.latitude)"
    }}
}

public class TBUndefinedLocation: TBLocation {
}
