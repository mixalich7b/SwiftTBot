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
    public var url: String?
    public var hideUrl: Bool?
    public var description: String?
    public var thumb_url: String?
    public var thumbWidth: Int?
    public var thumbHeight: Int?
    
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
    
    convenience public init(id: String, title: String, inputMessageContent: TBInputMessageContent, replyKeyboardMarkup: TBInlineKeyboardMarkup? = nil) {
        self.init(id: id, inputMessageContent: inputMessageContent, replyKeyboardMarkup: replyKeyboardMarkup)
        self.title = title
    }
}
