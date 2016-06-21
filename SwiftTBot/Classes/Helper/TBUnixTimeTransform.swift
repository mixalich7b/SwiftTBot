//
//  TBUnixTimeTransform.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper
import Foundation

public class TBUnixTimeTransform: TransformType {
    public typealias Object = NSDate
    public typealias JSON = Int
    
    public func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let timestamp = value as? Int {
            return NSDate(timeIntervalSince1970: TimeInterval(timestamp))
        }
        return nil
    }
    
    public func transformToJSON(value: NSDate?) -> Int? {
        if let date = value {
            return Int(date.timeIntervalSince1970)
        }
        return nil
    }
}
