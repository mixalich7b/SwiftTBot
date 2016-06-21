//
//  TBot.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper
import Foundation

internal typealias TBMessageHandlerClosure = (TBMessage) -> ()
internal typealias TBRegexMessageHandlerClosure = (TBMessage, NSRange) -> ()

internal typealias TBInlineQueryHandlerClosure = (TBInlineQuery, NSRange) -> ()

public class TBot {
    private let token: String
    public private(set) var botUsername: String?
    
    weak public var delegate: TBotDelegate?
    private var textCommandHandlers: [String: TBMessageHandlerClosure] = [:]
    private let textCommandHandlersQueue = DispatchQueue(label: "ru.mixalich7b.SwiftTBot.messageHandlers", attributes: .serial)
    private var regexCommandHandlers: [RegularExpression: TBRegexMessageHandlerClosure] = [:]
    private let regexCommandHandlersQueue = DispatchQueue(label: "ru.mixalich7b.SwiftTBot.regexHandlers", attributes: .serial)
    
    private var inlineQueryHandlers: [RegularExpression: TBInlineQueryHandlerClosure] = [:]
    private let inlineQueryHandlersQueue = DispatchQueue(label: "ru.mixalich7b.SwiftTBot.inlineHandlers", attributes: .serial)
    
    private let urlSession = URLSession(configuration: URLSessionConfiguration.ephemeral())
    private let responseProcessingQueue = DispatchQueue(label: "ru.mixalich7b.SwiftTBot.response", attributes: .concurrent)
    
    private var lastUpdateId = 0
    private let timeout = 10
    
    private var isRunning = false
    
    public init(token: String) {
        self.token = token
    }
    
    public func start(fallback:(TBError?) -> Void) {
        let getMeRequest = TBGetMeRequest()
        do {
            try self.sendRequest(request: getMeRequest) {[weak self] (response) in
                if !response.isOk {
                    fallback(response.error)
                } else {
                    self?.botUsername = response.responseEntities?.first?.username
                    self?.isRunning = true
                    self?.startPolling()
                }
            }
        } catch TBError.BadRequest {
            fallback(TBError.BadRequest)
        } catch {
            fallback(nil)
        }
    }
    
    public func stop() {
        self.isRunning = false
    }
    
    internal func setHandler(handler: TBMessageHandlerClosure?, forCommand textCommand: String) {
        self.textCommandHandlersQueue.async(group: .none, qos: .default, flags: .barrier) { 
            guard let handler = handler else {
                self.textCommandHandlers.removeValue(forKey: textCommand)
                return
            }
            self.textCommandHandlers[textCommand] = handler
        }
    }
    
    internal func setHandler(handler: TBRegexMessageHandlerClosure?, forRegexCommand regexCommand: RegularExpression) {
        self.regexCommandHandlersQueue.async(group: .none, qos: .default, flags: .barrier) {
            guard let handler = handler else {
                self.regexCommandHandlers.removeValue(forKey: regexCommand)
                return
            }
            self.regexCommandHandlers[regexCommand] = handler
        }
    }
    
    internal func setHandler(handler: TBInlineQueryHandlerClosure?, forInlineQueryRegex inlineQueryRegex: RegularExpression) {
        self.inlineQueryHandlersQueue.async(group: .none, qos: .default, flags: .barrier) {
            guard let handler = handler else {
                self.inlineQueryHandlers.removeValue(forKey: inlineQueryRegex)
                return
            }
            self.inlineQueryHandlers[inlineQueryRegex] = handler
        }
    }
    
    private func startPolling() {
        self.getUpdates {[weak self] in
            DispatchQueue.main.after(when: .now() + 3, execute: { 
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.isRunning {
                    strongSelf.startPolling()
                }
            })
        }
    }
    
    private func getUpdates(completion: () -> ()) {
        let updateRequest = TBGetUpdatesRequest(offset: self.lastUpdateId, limit: 100, timeout: timeout)
        do {
            try self.sendRequest(request: updateRequest) {[weak self] (response) in
                guard let strongSelf = self else {
                    return
                }
                completion()
                guard let updates = response.responseEntities else {
                    strongSelf.delegate?.didFailReceivingUpdates(fromBot: strongSelf, response: response)
                    return
                }
                let (messages, inlineQueries) = updates.reduce(([TBMessage](), [TBInlineQuery]()), combine: { (result: ([TBMessage], [TBInlineQuery]), update) -> ([TBMessage], [TBInlineQuery]) in
                    strongSelf.lastUpdateId = max(update.id + 1, strongSelf.lastUpdateId)
                    let messages = update.message.map{result.0 + [$0]} ?? result.0
                    let inlineQueries = update.inlineQuery.map{result.1 + [$0]} ?? result.1
                    return (messages, inlineQueries)
                })
                strongSelf.handleMessages(messages: messages)
                strongSelf.handleInlineQueries(inlineQueries: inlineQueries)
            }
        } catch {
            self.delegate?.didFailReceivingUpdates(fromBot: self, response: nil)
        }
    }
    
    private func handleMessages(messages: [TBMessage]) {
        for message in messages {
            guard let text = message.text else {
                continue
            }
            self.textCommandHandlersQueue.sync(execute: { 
                guard let handler = self.textCommandHandlers[text] else {
                    return
                }
                DispatchQueue.main.async {
                    handler(message)
                }
            })
            self.regexCommandHandlersQueue.sync(execute: { 
                for (regex, handler) in self.regexCommandHandlers {
                    let textRange = NSMakeRange(0, text.lengthOfBytes(using: String.Encoding.utf8))
                    let matchRange = regex.rangeOfFirstMatch(in: text, options: RegularExpression.MatchingOptions.reportCompletion, range: textRange)
                    if matchRange.location != NSNotFound {
                        DispatchQueue.main.async {
                            handler(message, matchRange)
                        }
                    }
                }
            })
        }
        self.delegate?.didReceiveMessages(messages: messages, fromBot: self)
    }
    
    private func handleInlineQueries(inlineQueries: [TBInlineQuery]) {
        for inlineQuery in inlineQueries {
            self.inlineQueryHandlersQueue.sync(execute: { 
                for (regex, handler) in self.inlineQueryHandlers {
                    let textRange = NSMakeRange(0, inlineQuery.text.lengthOfBytes(using: String.Encoding.utf8))
                    let matchRange = regex.rangeOfFirstMatch(in: inlineQuery.text, options: RegularExpression.MatchingOptions.reportCompletion, range: textRange)
                    if matchRange.location != NSNotFound {
                        DispatchQueue.main.async {
                            handler(inlineQuery, matchRange)
                        }
                    }
                }
            })
        }
        self.delegate?.didReceiveInlineQueries(inlineQueries: inlineQueries, fromBot: self)
    }
    
    public func sendRequest<ResponseEntity: TBEntity>(request: TBRequest<ResponseEntity>, completion: (TBResponse<ResponseEntity>) -> Void) throws {
        guard let URLRequest = TBNetworkRequestFabric.networkRequestWithRequest(request: request, token: self.token) else {
            throw TBError.BadRequest
        }
        let task = self.urlSession.dataTask(with: URLRequest) {[weak self] (data, requestResponse, requestError) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.responseProcessingQueue.async(execute: { 
                guard let responseData = data else {
                    let error = TBError.NetworkError(response: requestResponse, error: requestError)
                    DispatchQueue.main.async {
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.none, error: error))
                    }
                    return
                }
                let JSON: AnyObject?
                do {
                    try JSON = JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0))
                } catch {
                    JSON = Optional.none
                    let error = TBError.WrongResponseData(responseData: responseData, response: requestResponse, error: requestError)
                    DispatchQueue.main.async {
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.none, error: error))
                    }
                    return
                }
                guard let responseDictionary = JSON as? Dictionary<String, AnyObject> else {
                    let error = TBError.WrongResponseData(responseData: responseData, response: requestResponse, error: requestError)
                    DispatchQueue.main.async {
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.none, error: error))
                    }
                    return
                }
                
                guard let APIResponse = Mapper<TBResponse<ResponseEntity>>().map(JSONDictionary: responseDictionary) else {
                    let error = TBError.ResponseParsingError(responseDictionary: responseDictionary, response: requestResponse, error: requestError)
                    DispatchQueue.main.async {
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.none, error: error))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(APIResponse)
                }
            })
        }
        task.resume()
    }
}

