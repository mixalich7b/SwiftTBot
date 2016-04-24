//
//  AppDelegate.swift
//  EchoBotExample
//
//  Created by Тупицин Константин on 25.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Cocoa
import SwiftTBot

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, TBotDelegate {

    private let bot = TBot(token: "155474079:AAGhfQ3DB-KGFw26vbyYXRWnc-KwktXuexw")
    
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        bot.registerDelegate(self)
        do {
            try bot.start()
        } catch {
            print("Bot haven't started")
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    // MARK: TBotDelegate
    func didReceiveMessages(messages: [TBMessage], fromBot bot: TBot) -> Void {
        for message in messages {
            self.respondToMessage(message)
        }
    }
    
    private func respondToMessage(message: TBMessage) {
        guard let text = message.text else {
            return
        }
        let echoRequest = TBSendMessageRequest(chatId: message.chat.id, text: text)
        do {
            try self.bot.sendRequest(echoRequest, completion: { (response) in
                if !response.isOk {
                    print("API error: \(response.error?.description)")
                }
            })
        } catch TBError.BadRequest {
            print("Bad request")
        } catch {
            
        }
    }
}

