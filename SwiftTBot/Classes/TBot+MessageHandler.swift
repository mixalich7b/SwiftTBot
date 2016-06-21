//
//  TBot+MessageHandler.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 27.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Foundation

public typealias TBTextReplyClosure = (String) -> Void;

public extension TBot {
    // Async reply
    public func on(command: String, handler: (TBMessage, TBTextReplyClosure) -> Void) -> Self {
        self.setHandler(handler: { (message) in
            handler(message, {[weak self] (replyString) in
                let request = TBSendMessageRequest(chatId: message.chat.id, text: replyString, replyMarkup: TBReplyMarkupNone())
                self?.sendMessage(request: request)
            })
        }, forCommand: command)
        return self
    }
    
    // Sync reply
    public func on(command: String, handler: (TBMessage) -> String) -> Self {
        self.setHandler(handler: {[weak self] (message) in
            let replyString = handler(message)
            let request = TBSendMessageRequest(chatId: message.chat.id, text: replyString, replyMarkup: TBReplyMarkupNone())
            self?.sendMessage(request: request)
        }, forCommand: command)
        return self
    }
    
    // Regex based matching. Async reply
    public func on(regex: RegularExpression, handler: (TBMessage, NSRange, TBTextReplyClosure) -> Void) -> Self {
        self.setHandler(handler: { (message, range) in
            handler(message, range, {[weak self] (replyString) in
                let request = TBSendMessageRequest(chatId: message.chat.id, text: replyString, replyMarkup: TBReplyMarkupNone())
                self?.sendMessage(request: request)
            })
        }, forRegexCommand: regex)
        return self
    }
    
    private func sendMessage(request: TBSendMessageRequest<TBMessage, TBReplyMarkupNone>) {
        do {
            try self.sendRequest(request: request, completion: { (response) in
                if !response.isOk {
                    print("API error: \(response.error?.description)")
                }
            })
        } catch TBError.BadRequest {
            print("Bad request")
        } catch {
            print("")
        }
    }
}
