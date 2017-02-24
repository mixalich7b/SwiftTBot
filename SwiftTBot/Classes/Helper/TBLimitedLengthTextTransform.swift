//
//  TBLimitedLengthTextTransform.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 26.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBLimitedLengthTextTransform: TransformType {
    public typealias Object = String
    public typealias JSON = String
    
    private let maxLength: Int // in bytes
    
    public init(maxLength: Int) {
        self.maxLength = maxLength
    }
    
    public func transformFromJSON(_ value: Any?) -> String? {
        if let text = value as? String {
            return text
        }
        return nil
    }
    
    public func transformToJSON(_ value: String?) -> String? {
        if let text = value {
            let buffer = text.utf8
            if buffer.count > self.maxLength {
                return String(buffer[buffer.startIndex..<buffer.index(buffer.startIndex, offsetBy: self.maxLength)])
            } else {
                return text
            }
        }
        return nil
    }
}
