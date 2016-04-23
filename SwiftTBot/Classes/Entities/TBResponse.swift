//
//  TBResponse.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 23.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBResponse<T: TBEntity>: Mappable {
    public var isOk: Bool = false
    public var error: TBError?
    public var responseEntities: [T]?
    
//    let errorDescriptionTransorm = TransformOf<String, TBError>(fromJSON: {(value: String?) -> TBError? in
//        return value != nil ? TBError.ProtocolError(description: value) : Optional.None
//    }, toJSON: {(value: TBError?) -> Map? in
//        
//    })
    
    convenience init(isOk: Bool, responseEntities: [T]?, error: TBError?) {
        self.init(JSON: [:])!
        self.isOk = isOk
        self.responseEntities = responseEntities
        self.error = error
    }
    
    required public init?(_ map: Map) {
    }
    
    public func mapping(map: Map) {
        isOk <- map["ok"]
        error <- map["description"]
        responseEntities <- map["result"]
    }
}
