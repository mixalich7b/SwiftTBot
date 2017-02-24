//
//  TBInputLocationMessageContent.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 04.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBInputLocationMessageContent: TBInputMessageContent {
    private var longitude: Float = 0
    private var latitude: Float = 0
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        longitude <- map["longitude"]
        latitude <- map["latitude"]
    }
    
    convenience public init(longitude: Float, latitude: Float) {
        self.init()
        self.longitude = longitude
        self.latitude = latitude
    }
    
    public var debugDescription: String { get {
        return "lon: \(self.longitude), lat: \(self.latitude)"
    }}
}
