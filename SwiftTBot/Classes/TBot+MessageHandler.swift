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
    public func on(_ command: String, handler: @escaping (TBMessage, TBTextReplyClosure) -> Void) -> Self {
        self.setHandler({ (message) in
            handler(message, {[weak self] (replyString) in
                let request = TBSendMessageRequest(chatId: message.chat.id, text: replyString, replyMarkup: TBReplyMarkupNone())
                self?.sendMessage(request)
            })
        }, forCommand: command)
        return self
    }
    
    // Sync reply
    public func on(_ command: String, handler: @escaping (TBMessage) -> String) -> Self {
        self.setHandler({[weak self] (message) in
            let replyString = handler(message)
            let request = TBSendMessageRequest(chatId: message.chat.id, text: replyString, replyMarkup: TBReplyMarkupNone())
            self?.sendMessage(request)
        }, forCommand: command)
        return self
    }
    
    // Regex based matching. Async reply
    public func on(_ regex: NSRegularExpression, handler: @escaping (TBMessage, NSRange, TBTextReplyClosure) -> Void) -> Self {
        self.setHandler({ (message, range) in
            handler(message, range, {[weak self] (replyString) in
                let request = TBSendMessageRequest(chatId: message.chat.id, text: replyString, replyMarkup: TBReplyMarkupNone())
                self?.sendMessage(request)
            })
        }, forRegexCommand: regex)
        return self
    }
    
    private func sendMessage(_ request: TBSendMessageRequest<TBMessage, TBReplyMarkupNone>) {
        do {
            try self.sendRequest(request, completion: { (response) in
                if !response.isOk {
                    print("API error: \(response.error?.description)")
                }
            })
        } catch TBError.badRequest {
            print("Bad request")
        } catch {
            print("")
        }
    }
}
