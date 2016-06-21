//
//  TBSendMessageRequest.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public enum TBSendMessageParseMode: String {
    case None = ""
    case Markdown = "Markdown"
    case HTML = "HTML"
}

public class TBSendMessageRequest<Res: TBMessage, ReplyType where ReplyType: TBEntity, ReplyType: TBReplyMarkupProtocol>: TBRequest<Res> {
    override internal func getMethod() -> String {
        return "sendMessage"
    }
    
    var chatId: Int?
    var channelUsername: String?
    var text: String = ""
    var parseMode: TBSendMessageParseMode?
    var disableWebPagePreview: Bool?
    var disableNotification: Bool?
    var replyToMessageId: Int?
    var replyMarkup: ReplyType?
    
    override public init() {
        super.init()
    }
    
    convenience public init(chatId: Int, text: String, replyMarkup: ReplyType, parseMode: TBSendMessageParseMode = .None) {
        self.init()
        self.chatId = chatId
        self.text = text
        self.parseMode = parseMode
        self.replyMarkup = replyMarkup
    }
    
    convenience public init(channelUsername: String, text: String, replyMarkup: ReplyType, parseMode: TBSendMessageParseMode = .None) {
        self.init()
        self.channelUsername = channelUsername
        self.text = text
        self.parseMode = parseMode
        self.replyMarkup = replyMarkup
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        chatId <- map["chat_id"]
        channelUsername <- map["chat_id"]
        text <- map["text"]
        parseMode <- map["parse_mode"]
        disableWebPagePreview <- map["disable_web_page_preview"]
        disableNotification <- map["disable_notification"]
        replyToMessageId <- map["reply_to_message_id"]
        replyMarkup <- map["reply_markup"]
    }
}
