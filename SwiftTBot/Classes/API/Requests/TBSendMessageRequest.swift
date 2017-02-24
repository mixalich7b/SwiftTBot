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

public final class TBSendMessageRequest<Res: TBMessage, ReplyType>: TBRequest<Res> where ReplyType: TBEntity, ReplyType: TBReplyMarkupProtocol {
    override internal func getMethod() -> String {
        return "sendMessage"
    }
    
    private var chatId: Int?
    private var channelUsername: String?
    private var text: String = ""
    private var parseMode: TBSendMessageParseMode?
    private var disableWebPagePreview: Bool?
    private var disableNotification: Bool?
    private var replyToMessageId: Int?
    private var replyMarkup: ReplyType?
    
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
