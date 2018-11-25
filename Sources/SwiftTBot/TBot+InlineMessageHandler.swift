//
//  TBot+InlineMessageHandler.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 06.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Foundation

public struct InlineQueryReply {
    private let replyClosure: ([TBInlineQueryResult]) -> Void
    
    public func send(_ results: [TBInlineQueryResult]) {
        replyClosure(results)
    }
    
    internal init(replyClosure: @escaping ([TBInlineQueryResult]) -> Void) {
        self.replyClosure = replyClosure
    }
}

public extension TBot {
    // Regex based matching. Async reply
    @discardableResult
    public func onInline(_ regex: NSRegularExpression, handler: @escaping (TBInlineQuery, NSRange, InlineQueryReply) -> Void) -> Self {
        self.setHandler({ (inlineQuery, range) in
            let inlineQueryReply = InlineQueryReply(replyClosure: {[weak self] (results) in
                let request = TBAnswerInlineQueryRequest(inlineRequestId: inlineQuery.id, results:  results)
                self?.sendInlineAnswer(request)
            })
            handler(inlineQuery, range, inlineQueryReply)
        }, forInlineQueryRegex: regex)
        return self
    }
    
    private func sendInlineAnswer(_ request: TBAnswerInlineQueryRequest<TBEntity>) {
        do {
            try self.sendRequest(request, completion: { (response) in
                if !response.isOk {
                    print("API error: \(response.error?.description ?? "unknown")")
                }
            })
        } catch TBError.badRequest {
            print("Bad request")
        } catch {
            print("")
        }
    }
}
