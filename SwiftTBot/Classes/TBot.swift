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
    
    private var delegates: NSPointerArray = NSPointerArray.weakObjectsPointerArray()
    private let delegatesOperatingQueue = dispatch_queue_create("ru.mixalich7b.TBot.delegates", DISPATCH_QUEUE_SERIAL)
    private let URLSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    
    public init(token: String) {
        self.token = token
    }
    
    public func registerDelegate(delegate: TBotDelegate) {
        dispatch_barrier_async(self.delegatesOperatingQueue) {[unowned self] _ in
            self.delegates.addPointer(UnsafeMutablePointer(unsafeAddressOf(delegate)))
        }
    }
    
    public func start() throws {
        let request = TBGetMeRequest()
        try self.sendRequest(request) { (response) in
            response.responseEntities?.first?.firstName
        }
    }
    
    private func sendRequest<ResponseEntity: TBEntity>(request: TBRequest<ResponseEntity>, completion: (TBResponse<ResponseEntity>) -> Void) throws {
        guard let URLRequest = TBNetworkRequestFabric.networkRequestWithRequest(request, token: self.token) else {
            throw TBError.WrongRequest
        }
        self.URLSession.dataTaskWithRequest(URLRequest) { (data, requestResponse, requestError) in
            guard let responseData = data else {
                let error = TBError.NetworkError(response: requestResponse, error: requestError)
                completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.None, error: error))
                return
            }
            let JSON: AnyObject?
            do {
                try JSON = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions(rawValue: 0))
            } catch {
                JSON = Optional.None
                let error = TBError.WrongResponseData(responseData: responseData, response: requestResponse, error: requestError)
                completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.None, error: error))
                return
            }
            guard let responseDictionary = JSON as? Dictionary<String, AnyObject> else {
                let error = TBError.WrongResponseData(responseData: responseData, response: requestResponse, error: requestError)
                completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.None, error: error))
                return
            }
            
            guard let APIResponse = Mapper<TBResponse<ResponseEntity>>().map(responseDictionary) else {
                let error = TBError.ResponseParsingError(responseDictionary: responseDictionary, response: requestResponse, error: requestError)
                completion(TBResponse<ResponseEntity>(isOk: false, responseEntities: Optional.None, error: error))
                return
            }
            completion(APIResponse)
        }
    }
}

