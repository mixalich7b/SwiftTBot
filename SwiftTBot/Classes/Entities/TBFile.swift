//
//  TBFile.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBFile: TBEntity {
    public var fileId: String = ""
    public var fileSize: Int = -1
    public var filePath: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        fileId <- map["file_id"]
        fileSize <- map["file_size"]
        filePath <- map["file_path"]
    }
}
