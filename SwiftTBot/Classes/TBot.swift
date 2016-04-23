//
//  TBot.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Foundation

public class TBot {
    private let token: String
    
    private var delegates: NSPointerArray = NSPointerArray.weakObjectsPointerArray()
    private let delegatesOperatingQueue = dispatch_queue_create("ru.mixalich7b.TBot.delegates", DISPATCH_QUEUE_SERIAL)
    
    public init(token: String) {
        self.token = token
    }
    
    public func registerDelegate(delegate: TBotDelegate) {
        dispatch_barrier_async(self.delegatesOperatingQueue) {[unowned self] _ in
            self.delegates.addPointer(UnsafeMutablePointer(unsafeAddressOf(delegate)))
        }
    }
    
    public func start() {
        let request = TBGetMeRequest()
        self.sendRequest(request) { (response) in
            response.responseEntities?.first?.firstName
        }
    }
    
    private func sendRequest<ResponseEntity: TBEntity>(request: TBRequest<ResponseEntity>, completion: (TBResponse<ResponseEntity>) -> Void) {
        let URLRequest = TBNetworkRequestFabric.networkRequestWithRequest(request, token: self.token)
        
    }
}

