//
//  TBot+MessageHandler.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 27.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

public typealias TBTextReplyCallback = String -> Void;

public extension TBot {
    public func on(command: String, handler: (TBMessage, TBTextReplyCallback) -> Void) -> Self {
        self.setHandler({ (message) in
            handler(message, {[weak self] (replyString) in
                guard let strongSelf = self else {
                    return
                }
                let request = TBSendMessageRequest(chatId: message.chat.id, text: replyString, replyMarkup: TBReplyMarkupNone())
                strongSelf.sendMessage(request)
            })
        }, forCommand: command)
        return self
    }
    
    public func on(command: String, handler: TBMessage -> String) -> Self {
        self.setHandler({[weak self] (message) in
            let replyString = handler(message)
            guard let strongSelf = self else {
                return
            }
            let request = TBSendMessageRequest(chatId: message.chat.id, text: replyString, replyMarkup: TBReplyMarkupNone())
            strongSelf.sendMessage(request)
        }, forCommand: command)
        return self
    }
    
    private func sendMessage<ReplyType where ReplyType: TBEntity, ReplyType: TBReplyMarkupProtocol>(request: TBSendMessageRequest<TBEntity, ReplyType>) {
        do {
            try self.sendRequest(request, completion: { (response) in
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
