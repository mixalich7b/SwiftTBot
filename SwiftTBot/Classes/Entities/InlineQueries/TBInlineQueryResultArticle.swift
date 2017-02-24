//
//  TBInlineQueryResultArticle.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 03.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public final class TBInlineQueryResultArticle: TBInlineQueryResult {
    override internal var type: String {get {
        return "article"
    } set {
    }}
    
    private var title: String = ""
    private var url: String?
    private var hideUrl: Bool?
    private var description: String?
    private var thumb_url: String?
    private var thumbWidth: Int?
    private var thumbHeight: Int?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        url <- map["url"]
        hideUrl <- map["hide_url"]
        description <- map["description"]
        thumb_url <- map["thumb_url"]
        thumbWidth <- map["thumb_width"]
        thumbHeight <- map["thumb_height"]
    }
    
    convenience public init(id: String, title: String, inputMessageContent: TBInputMessageContent) {
        self.init(id: id)
        self.title = title
        self.inputMessageContent = inputMessageContent
    }
}
