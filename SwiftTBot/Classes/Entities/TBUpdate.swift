//
//  TBUpdate.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBUpdate: TBEntity {
    public var id: Int = 0
    public var message: TBMessage?
    
    required public init?(_ map: Map) {
        super.init(map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        id <- map["update_id"]
        message <- map["message"]
    }
}
