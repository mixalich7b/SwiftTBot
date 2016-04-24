//
//  TBotDelegate.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 22.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Foundation

public protocol TBotDelegate : AnyObject {
    func didReceiveMessages(messages: [TBMessage], fromBot bot: TBot) -> Void
}