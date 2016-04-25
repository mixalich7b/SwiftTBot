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

public class TBSendMessageRequest<Res: TBEntity, ReplyType where ReplyType: TBEntity, ReplyType: TBReplyMarkupProtocol>: TBRequest<Res> {
    override internal func getMethod() -> String {
        return "sendMessage"
    }
    
    var chatId: Int?
    var channelUsername: String?
    var text: String! = ""
    var parseMode: TBSendMessageParseMode?
    var disableWebPagePreview: Bool?
    var disableNotification: Bool?
    var replyToMessageId: Int?
    var replyMarkup: ReplyType?
    
    required public init?(JSON: [String : AnyObject]) {
        super.init(JSON: JSON)
    }
    
    convenience public init(chatId: Int, text: String, parseMode: TBSendMessageParseMode = .None) {
        self.init(JSON: [:])!
        self.chatId = chatId
        self.text = text
        self.parseMode = parseMode
    }
    
    convenience public init(channelUsername: String, text: String, parseMode: TBSendMessageParseMode = .None) {
        self.init(JSON: [:])!
        self.channelUsername = channelUsername
        self.text = text
        self.parseMode = parseMode
    }
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        chatId <- map["chat_id"]
        channelUsername <- map["chat_id"]
        text <- map["text"]
        parseMode <- (map["parse_mode"], EnumTransform<TBSendMessageParseMode>())
        disableWebPagePreview <- map["disable_web_page_preview"]
        disableNotification <- map["disable_notification"]
        replyToMessageId <- map["reply_to_message_id"]
        replyMarkup <- map["reply_markup"]
    }
}
