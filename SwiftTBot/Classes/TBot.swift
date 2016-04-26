//
//  TBot.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBot {
    private let token: String
    public private(set) var botUsername: String?
    
    weak public var delegate: TBotDelegate?
    
    private let URLSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    private let responseProcessingQueue = dispatch_queue_create("ru.mixalich7b.SwiftTBot.response", DISPATCH_QUEUE_CONCURRENT)
    
    private var lastUpdateId = 0
    private let timeout = 10
    
    private var isRunning = false
    
    public init(token: String) {
        self.token = token
    }
    
    public func start(fallback:(TBError?) -> Void) {
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
        } catch TBError.BadRequest {
            fallback(TBError.BadRequest)
        } catch {
            fallback(nil)
        }
    }
    
    public func stop() {
        self.isRunning = false
    }
    
    private func startPolling() {
        self.getUpdates {[weak self] in
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.isRunning {
                    strongSelf.startPolling()
                }
            }
        }
    }
    
    private func getUpdates(completion: () -> ()) {
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
                let messages = updates.reduce([TBMessage](), combine: { (messages:[TBMessage], update) -> [TBMessage] in
                    strongSelf.lastUpdateId = max(update.id + 1, strongSelf.lastUpdateId)
                    return update.message.map{messages + [$0]} ?? messages
                })
                strongSelf.delegate?.didReceiveMessages(messages, fromBot: strongSelf)
            }
        } catch {
            self.delegate?.didFailReceivingUpdates(fromBot: self, response: nil)
        }
    }
    
    public func sendRequest<ResponseEntity: TBEntity>(request: TBRequest<ResponseEntity>, completion: (TBResponse<ResponseEntity>) -> Void) throws {
        guard let URLRequest = TBNetworkRequestFabric.networkRequestWithRequest(request, token: self.token) else {
            throw TBError.BadRequest
        }
        let task = self.URLSession.dataTaskWithRequest(URLRequest) {[weak self] (data, requestResponse, requestError) in
            guard let strongSelf = self else {
                return
            }
            dispatch_async(strongSelf.responseProcessingQueue, { 
                guard let responseData = data else {
                    let error = TBError.NetworkError(response: requestResponse, error: requestError)
                    dispatch_async(dispatch_get_main_queue(), { 
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.None, error: error))
                    })
                    return
                }
                let JSON: AnyObject?
                do {
                    try JSON = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions(rawValue: 0))
                } catch {
                    JSON = Optional.None
                    let error = TBError.WrongResponseData(responseData: responseData, response: requestResponse, error: requestError)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.None, error: error))
                    })
                    return
                }
                guard let responseDictionary = JSON as? Dictionary<String, AnyObject> else {
                    let error = TBError.WrongResponseData(responseData: responseData, response: requestResponse, error: requestError)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.None, error: error))
                    })
                    return
                }
                
                guard let APIResponse = Mapper<TBResponse<ResponseEntity>>().map(responseDictionary) else {
                    let error = TBError.ResponseParsingError(responseDictionary: responseDictionary, response: requestResponse, error: requestError)
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.None, error: error))
                    })
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    completion(APIResponse)
                })
            })
        }
        task.resume()
    }
}

