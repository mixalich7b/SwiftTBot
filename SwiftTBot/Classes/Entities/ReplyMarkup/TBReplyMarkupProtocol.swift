//
//  TBReplyMarkupProtocol.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 26.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

public protocol TBReplyMarkupProtocol {
}

public class TBReplyMarkupNone: TBEntity, TBReplyMarkupProtocol {
    public convenience init() {
        self.init(JSON: [:])!
    }
}