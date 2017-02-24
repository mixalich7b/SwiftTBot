//
//  TBot+InlineMessageHandler.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 06.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Foundation

public typealias TBInlineReplyClosure = ([TBInlineQueryResult]) -> Void;

public extension TBot {
    // Regex based matching. Async reply
    public func onInline(_ regex: NSRegularExpression, handler: @escaping (TBInlineQuery, NSRange, TBInlineReplyClosure) -> Void) -> Self {
        self.setHandler({ (inlineQuery, range) in
            handler(inlineQuery, range, {[weak self] (results) in
                let request = TBAnswerInlineQueryRequest(inlineRequestId: inlineQuery.id, results:  results)
                self?.sendInlineAnswer(request)
            })
        }, forInlineQueryRegex: regex)
        return self
    }
    
    private func sendInlineAnswer(_ request: TBAnswerInlineQueryRequest<TBEntity>) {
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
