//
//  TBRequest.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 23.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBRequest<Res: TBEntity>: Mappable {
    internal func getMethod() -> String {
        assert(false, "Must be overriden")
        return ""
    }
    
    required public init?(_ map: Map) {
    }
    
    public func mapping(map: Map) {
    }
    
    public init() {
    }
}
