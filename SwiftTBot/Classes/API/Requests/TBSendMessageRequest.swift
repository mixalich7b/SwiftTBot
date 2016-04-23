//
//  TBSendMessageRequest.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBSendMessageRequest: TBRequest<TBEntity> {
    override internal func getMethod() -> String {
        return "sendMessage"
    }
    
    var chatId: Int?
    var channelUsername: String?
    var text: String! = ""
    
    convenience public init(chatId: Int, text: String) {
        self.init(JSON: [:])!
        self.chatId = chatId
        self.text = text
    }
    
    convenience public init(channelUsername: String, text: String) {
        self.init(JSON: [:])!
        self.channelUsername = channelUsername
        self.text = text
    }
    
    override public func mapping(map: Map) {
        super.mapping(map)
        
        chatId <- map["chat_id"]
        channelUsername <- map["chat_id"]
        text <- map["text"]
    }
}
