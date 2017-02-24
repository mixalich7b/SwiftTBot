//
//  TBUnixTimeTransform.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBUnixTimeTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = Int
    
    public func transformFromJSON(_ value: Any?) -> Date? {
        if let timestamp = value as? Int {
            return Date(timeIntervalSince1970: TimeInterval(timestamp))
        }
        return nil
    }
    
    public func transformToJSON(_ value: Date?) -> Int? {
        if let date = value {
            return Int(date.timeIntervalSince1970)
        }
        return nil
    }
}
