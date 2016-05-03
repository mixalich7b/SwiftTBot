//
//  TBInputLocationMessageContent.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 04.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBInputLocationMessageContent: TBInputMessageContent {
    public var longitude: Float = 0
    public var latitude: Float = 0
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        longitude <- map["longitude"]
        latitude <- map["latitude"]
    }
    
    override public init() {
        super.init()
    }
    
    required public init?(_ map: Map) {
        super.init(map)
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
