//
//  TBResponse.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 23.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBResponse<T: TBEntity>: Mappable {
    internal var isOk: Bool = false
    internal var error: TBError?
    internal var responseEntities: [T]?
    
    private let errorDescriptionTransorm = TransformOf<TBError, String>(fromJSON: {(value: String?) -> TBError? in
        return value.map{TBError.protocolError(description: $0)}
    }, toJSON: {(value: TBError?) -> String? in
        return value?.description
    })
    
    private init() {
    }
    
    convenience internal init(isOk: Bool, responseEntities: [T]?, error: TBError?) {
        self.init()
        self.isOk = isOk
        self.responseEntities = responseEntities
        self.error = error
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        isOk <- map["ok"]
        error <- (map["description"], errorDescriptionTransorm)
        responseEntities <- map["result"]
        if responseEntities == nil {
            var responseEntity: T?
            responseEntity <- map["result"]
            guard let singleEntity = responseEntity else {
                return
            }
            responseEntities = [singleEntity]
        }
    }
}
