//
//  TBForceReply.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 26.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBForceReply: TBEntity, TBReplyMarkupProtocol {
    private var forceReply: Bool = true
    public var selective: Bool?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        forceReply <- map["force_reply"]
        selective <- map["selective"]
    }
}
