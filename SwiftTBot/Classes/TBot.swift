//
//  TBot.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

internal typealias TBMessageHandlerClosure = (TBMessage) -> ()
internal typealias TBRegexMessageHandlerClosure = (TBMessage, NSRange) -> ()

internal typealias TBInlineQueryHandlerClosure = (TBInlineQuery, NSRange) -> ()

public final class TBot {
    private let token: String
    public private(set) var botUsername: String?
    
    weak public var delegate: TBotDelegate?
    private var textCommandHandlers: [String: TBMessageHandlerClosure] = [:]
    private let textCommandHandlersQueue = DispatchQueue(label: "ru.mixalich7b.SwiftTBot.messageHandlers", attributes: [])
    private var regexCommandHandlers: [NSRegularExpression: TBRegexMessageHandlerClosure] = [:]
    private let regexCommandHandlersQueue = DispatchQueue(label: "ru.mixalich7b.SwiftTBot.regexHandlers", attributes: [])
    
    private var inlineQueryHandlers: [NSRegularExpression: TBInlineQueryHandlerClosure] = [:]
    private let inlineQueryHandlersQueue = DispatchQueue(label: "ru.mixalich7b.SwiftTBot.inlineHandlers", attributes: [])
    
    private let URLSession = Foundation.URLSession(configuration: URLSessionConfiguration.ephemeral)
    private let responseProcessingQueue = DispatchQueue(label: "ru.mixalich7b.SwiftTBot.response", attributes: DispatchQueue.Attributes.concurrent)
    
    private var lastUpdateId = 0
    private let timeout = 10
    
    private var isRunning = false
    
    public init(token: String) {
        self.token = token
    }
    
    public func start(_ fallback:@escaping (TBError?) -> Void) {
        let getMeRequest = TBGetMeRequest()
        do {
            try self.sendRequest(getMeRequest) {[weak self] (response) in
                if !response.isOk {
                    fallback(response.error)
                } else {
                    self?.botUsername = response.responseEntities?.first?.username
                    self?.isRunning = true
                    self?.startPolling()
                }
            }
        } catch TBError.badRequest {
            fallback(TBError.badRequest)
        } catch {
            fallback(nil)
        }
    }
    
    public func stop() {
        self.isRunning = false
    }
    
    internal func setHandler(_ handler: TBMessageHandlerClosure?, forCommand textCommand: String) {
        self.textCommandHandlersQueue.async(flags: .barrier, execute: {
            guard let handler = handler else {
                self.textCommandHandlers.removeValue(forKey: textCommand)
                return
            }
            self.textCommandHandlers[textCommand] = handler
        }) 
    }
    
    internal func setHandler(_ handler: TBRegexMessageHandlerClosure?, forRegexCommand regexCommand: NSRegularExpression) {
        self.regexCommandHandlersQueue.async(flags: .barrier, execute: {
            guard let handler = handler else {
                self.regexCommandHandlers.removeValue(forKey: regexCommand)
                return
            }
            self.regexCommandHandlers[regexCommand] = handler
        }) 
    }
    
    internal func setHandler(_ handler: TBInlineQueryHandlerClosure?, forInlineQueryRegex inlineQueryRegex: NSRegularExpression) {
        self.inlineQueryHandlersQueue.async(flags: .barrier, execute: {
            guard let handler = handler else {
                self.inlineQueryHandlers.removeValue(forKey: inlineQueryRegex)
                return
            }
            self.inlineQueryHandlers[inlineQueryRegex] = handler
        }) 
    }
    
    private func startPolling() {
        self.getUpdates {[weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.isRunning {
                    strongSelf.startPolling()
                }
            }
        }
    }
    
    private func getUpdates(_ completion: @escaping () -> ()) {
        let updateRequest = TBGetUpdatesRequest(offset: self.lastUpdateId, limit: 100, timeout: timeout)
        do {
            try self.sendRequest(updateRequest) {[weak self] (response) in
                guard let strongSelf = self else {
                    return
                }
                completion()
                guard let updates = response.responseEntities else {
                    strongSelf.delegate?.didFailReceivingUpdates(fromBot: strongSelf, response: response)
                    return
                }
                let (messages, inlineQueries) = updates.reduce(([TBMessage](), [TBInlineQuery]()), { (result: ([TBMessage], [TBInlineQuery]), update) -> ([TBMessage], [TBInlineQuery]) in
                    strongSelf.lastUpdateId = max(update.id + 1, strongSelf.lastUpdateId)
                    let messages = update.message.map{result.0 + [$0]} ?? result.0
                    let inlineQueries = update.inlineQuery.map{result.1 + [$0]} ?? result.1
                    return (messages, inlineQueries)
                })
                strongSelf.handleMessages(messages)
                strongSelf.handleInlineQueries(inlineQueries)
            }
        } catch {
            self.delegate?.didFailReceivingUpdates(fromBot: self, response: nil)
        }
    }
    
    private func handleMessages(_ messages: [TBMessage]) {
        for message in messages {
            guard let text = message.text else {
                continue
            }
            self.textCommandHandlersQueue.sync(execute: {
                guard let handler = self.textCommandHandlers[text] else {
                    return
                }
                DispatchQueue.main.async(execute: {
                    handler(message)
                })
            })
            self.regexCommandHandlersQueue.sync(execute: {
                for (regex, handler) in self.regexCommandHandlers {
                    let textRange = NSMakeRange(0, text.lengthOfBytes(using: String.Encoding.utf8))
                    let matchRange = regex.rangeOfFirstMatch(in: text, options: NSRegularExpression.MatchingOptions.reportCompletion, range: textRange)
                    if matchRange.location != NSNotFound {
                        DispatchQueue.main.async(execute: {
                            handler(message, matchRange)
                        })
                    }
                }
            })
        }
        self.delegate?.didReceiveMessages(messages, fromBot: self)
    }
    
    private func handleInlineQueries(_ inlineQueries: [TBInlineQuery]) {
        for inlineQuery in inlineQueries {
            self.inlineQueryHandlersQueue.sync(execute: {
                for (regex, handler) in self.inlineQueryHandlers {
                    let textRange = NSMakeRange(0, inlineQuery.text.lengthOfBytes(using: String.Encoding.utf8))
                    let matchRange = regex.rangeOfFirstMatch(in: inlineQuery.text, options: NSRegularExpression.MatchingOptions.reportCompletion, range: textRange)
                    if matchRange.location != NSNotFound {
                        DispatchQueue.main.async(execute: {
                            handler(inlineQuery, matchRange)
                        })
                    }
                }
            })
        }
        self.delegate?.didReceiveInlineQueries(inlineQueries, fromBot: self)
    }
    
    internal func sendRequest<ResponseEntity: TBEntity>(_ request: TBRequest<ResponseEntity>, completion: @escaping (TBResponse<ResponseEntity>) -> Void) throws {
        guard let URLRequest = TBNetworkRequestFabric.networkRequestWithRequest(request, token: self.token) else {
            throw TBError.badRequest
        }
        let task = self.URLSession.dataTask(with: URLRequest, completionHandler: {[weak self] (data, requestResponse, requestError) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.responseProcessingQueue.async(execute: { 
                guard let responseData = data else {
                    let error = TBError.networkError(response: requestResponse, error: requestError)
                    DispatchQueue.main.async(execute: { 
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.none, error: error))
                    })
                    return
                }
                let JSON: Any?
                do {
                    try JSON = JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0))
                } catch {
                    JSON = Optional.none
                    let error = TBError.wrongResponseData(responseData: responseData, response: requestResponse, error: requestError)
                    DispatchQueue.main.async(execute: {
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.none, error: error))
                    })
                    return
                }
                guard let responseDictionary = JSON as? Dictionary<String, Any> else {
                    let error = TBError.wrongResponseData(responseData: responseData, response: requestResponse, error: requestError)
                    DispatchQueue.main.async(execute: {
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.none, error: error))
                    })
                    return
                }
                
                guard let APIResponse = Mapper<TBResponse<ResponseEntity>>().map(JSON: responseDictionary) else {
                    let error = TBError.responseParsingError(responseDictionary: responseDictionary, response: requestResponse, error: requestError)
                    DispatchQueue.main.async(execute: {
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.none, error: error))
                    })
                    return
                }
                DispatchQueue.main.async(execute: {
                    completion(APIResponse)
                })
            })
        }) 
        task.resume()
    }
}

