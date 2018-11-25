//
//  TBMessageEntity.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public enum TBMessageEntityType: String {
    case Undefined = "undefined"
    case Mention = "mention"
    case Hashtag = "hashtag"
    case BotCommand = "bot_command"
    case URL = "url"
    case Email = "email"
    case BoldText = "bold"
    case ItalicText = "italic"
    case MonospacedString = "code"
    case MonospacedText = "pre"
    case Link = "text_link"
}

public final class TBMessageEntity: TBEntity {
    public private(set) var type: TBMessageEntityType = .Undefined
    public private(set) var offset: Int = -1 // in UTF-16 code units
    public private(set) var length: Int = -1 // in UTF-16 code units
    public private(set) var url: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        type <- map["type"]
        offset <- map["offset"]
        length <- map["length"]
        url <- map["url"]
    }
}
