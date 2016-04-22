//
//  TBot.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Foundation

public typealias MessageUpdateHandler = (TBMessage) -> ()

public class TBot {
    private let token: String
    
    private var messageUpdateHandlers: [MessageUpdateHandler] = []
    
    public init(token: String) {
        self.token = token
    }
    
    public func registerMessageHandler(handlerClosure: MessageUpdateHandler) {
        self.messageUpdateHandlers.append(handlerClosure)
    }
    
    public func unregisterMessageHandler(handlerClosure: MessageUpdateHandler) {
        
    }
}
