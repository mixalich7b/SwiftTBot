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

    private let bot = TBot(token: "<your_token>")
    
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        bot.delegate = self
        bot.start { (error) in
            print("Bot haven't started, error: \(error)")
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
    
    func didFailReceivingUpdates<Res: TBEntity>(fromBot bot: TBot, response: TBResponse<Res>?) {
        print("Receiving updates failure: \(response?.error)")
    }
    
    private func respondToMessage(message: TBMessage) {
        guard let text = message.text else {
            return
        }
        let replyHTML = "<i>\(text)</i>\n<a href='http://www.instml.com/'>Instaml</a>";
        let keyboard = TBReplyKeyboardMarkup(keyboard: [
            [TBKeyboardButton(text: "Contact", requestContact: true)],
            [TBKeyboardButton(text: "Location", requestLocation: true)]
            ]);
        keyboard.selective = true
        keyboard.oneTimeKeyboard = true
        let echoRequest = TBSendMessageRequest(chatId: message.chat.id, text: replyHTML, replyMarkup: keyboard, parseMode: .HTML)
        do {
            try self.bot.sendRequest(echoRequest, completion: { (response) in
                if !response.isOk {
                    print("API error: \(response.error?.description)")
                }
            })
        } catch TBError.BadRequest {
            print("Bad request")
        } catch {
            print("")
        }
    }
}

