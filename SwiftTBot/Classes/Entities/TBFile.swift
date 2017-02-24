//
//  TBFile.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBFile: TBEntity {
    public private(set) var fileId: String = ""
    public private(set) var fileSize: Int = -1
    public private(set) var filePath: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        fileId <- map["file_id"]
        fileSize <- map["file_size"]
        filePath <- map["file_path"]
    }
}
