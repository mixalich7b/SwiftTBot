//
//  TBInlineQueryResultArticle.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 03.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBInlineQueryResultArticle: TBInlineQueryResult {
    override internal var type: String {get {
        return "article"
    } set {
    }}
    
    public var title: String = ""
    public var url: String?
    public var hideUrl: Bool?
    public var description: String?
    public var thumb_url: String?
    public var thumbWidth: Int?
    public var thumbHeight: Int?
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        title <- map["title"]
        url <- map["url"]
        hideUrl <- map["hide_url"]
        description <- map["description"]
        thumb_url <- map["thumb_url"]
        thumbWidth <- map["thumb_width"]
        thumbHeight <- map["thumb_height"]
    }
    
    override internal init(id: String) {
        super.init(id: id)
    }
    
    required public init?(_ map: Map) {
        super.init(map)
    }
    
    convenience public init(id: String, title: String, inputMessageContent: TBInputMessageContent) {
        self.init(id: id)
        self.title = title
        self.inputMessageContent = inputMessageContent
    }
}
