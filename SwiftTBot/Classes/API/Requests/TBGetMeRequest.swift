//
//  TBGetMeRequest.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBGetMeRequest<Res: TBUser>: TBRequest<Res> {
    override internal func getMethod() -> String {
        return "getMe"
    }
    
    override public init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
}
