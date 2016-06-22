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

    private let bot = TBot(token: <your_token>)
    
    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        bot.delegate = self
//        _ = self.bot.on(command: "/start") { "Hello, \($0.from?.firstName ?? $0.chat.firstName ?? "" )"}
//            .on(command: "/test") { _ in "It's work"}
//            .on(command: "/info") {[weak self] (message, replyCallback) in
//                do {
//                    try self?.bot.sendRequest(request: TBGetMeRequest(), completion: { (response) in
//                        if let username = response.responseEntities?.first?.username {
//                            replyCallback("\(username)\nhttps://telegram.me/\(username)")
//                        }
//                    })
//                } catch {
//                }
//        }
//
        let awesomeCommandRegex = try! RegularExpression(pattern: "^(\\/awesome)\\s([0-9]{1,4})\\s([0-9]{1,4})$", options: RegularExpression.Options(rawValue: 0))
//        let argsParsingRegex = try! NSRegularExpression(pattern: "([0-9]{1,4})", options: NSRegularExpressionOptions(rawValue: 0))
//        bot.on(awesomeCommandRegex) { (message, matchRange, callback) in
//            guard let text = message.text else {
//                return
//            }
//            
//            let replyString = argsParsingRegex.matchesInString(text, options: NSMatchingOptions.ReportProgress, range: matchRange)
//                .reduce("Args: ", combine: { (replyText, checkResult) -> String in
//                    let startOffset = checkResult.range.location
//                    let endOffset = checkResult.range.location + checkResult.range.length
//                    let range = text.startIndex.advancedBy(startOffset)..<text.startIndex.advancedBy(endOffset)
//                    return replyText + text.substringWithRange(range) + ", "
//                })
//            callback(replyString)
//        }
        
        _ = self.bot.onInline(regex: awesomeCommandRegex) { (inlineQuery, range, callback) in
        let article1 = TBInlineQueryResultArticle(id: "\(arc4random_uniform(1000))", title: "Test title", inputMessageContent: TBInputTextMessageContent(messageText: "Test text"))
        article1.url = "google.com"
        callback([article1])
        }
        
        
        self.bot.start { (error) in
            print("Bot haven't started, error: \(error)")
        }
    
        let sendTestMessageRequest = TBSendMessageRequest(chatId: 1657203, text: "Hello, man!", replyMarkup: TBReplyMarkupNone(), parseMode: .None)
        do {
            try self.bot.sendRequest(request: sendTestMessageRequest, completion: { (response) in
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

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: TBotDelegate
    func didReceiveMessages(messages: [TBMessage], fromBot bot: TBot) -> Void {
        for message in messages {
            self.respondToMessage(message: message)
        }
    }
    
    func didReceiveInlineQueries(inlineQueries: [TBInlineQuery], fromBot bot: TBot) -> Void {
        for _ in inlineQueries {
//            self.respondToInlineQuery(inlineQuery)
        }
    }
    
    func didFailReceivingUpdates<Res: TBEntity>(fromBot bot: TBot, response: TBResponse<Res>?) {
        print("Receiving updates failure: \(response?.error)")
    }
    
    private func respondToMessage(message: TBMessage) {
        let text = message.text
        let contact = message.contact
        let location = message.location
        
        let replyText = text ?? contact.map{"\($0.phoneNumber), \($0.firstName)"} ?? location?.debugDescription ?? "Hello!"
        let replyHTML = "<i>\(replyText)</i>\n<a href='http://www.instml.com/'>Instaml</a>";
        
        let keyboard = TBReplyKeyboardMarkup(buttons: [
            [TBKeyboardButton(text: "Contact", requestContact: true)],
            [TBKeyboardButton(text: "Location", requestLocation: true)]
            ]);
        keyboard.selective = true
        keyboard.oneTimeKeyboard = true
        let echoRequest = TBSendMessageRequest(chatId: message.chat.id, text: replyHTML, replyMarkup: keyboard, parseMode: .HTML)
        do {
            try self.bot.sendRequest(request: echoRequest, completion: { (response) in
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
    
    private func respondToInlineQuery(_ inlineQuery: TBInlineQuery) {
        let article1 = TBInlineQueryResultArticle(id: "\(arc4random_uniform(1000))", title: "Test title", inputMessageContent: TBInputTextMessageContent(messageText: "Test text"))
        article1.url = "google.com"
        let article2 = TBInlineQueryResultArticle(id: "\(arc4random_uniform(1000))", title: "Awesome article", inputMessageContent: TBInputLocationMessageContent(longitude: 98.292905, latitude: 7.817627))
        article2.url = "vk.com"
        let article3 = TBInlineQueryResultArticle(id: "\(arc4random_uniform(1000))", title: "Echo result", inputMessageContent: TBInputTextMessageContent(messageText: "Echo: \(inlineQuery.text)"))
        article3.url = "youtube.com"
        article3.description = "Echo: \(inlineQuery.text),\noffset: \(inlineQuery.offset)"
        
        let btn1 = TBInlineKeyboardButton()
        btn1.text =  "Btn1"
        btn1.url = "2ch.hk/b"
        btn1.callbackData = "btn1"
        let btn2 = TBInlineKeyboardButton()
        btn2.text =  "Btn2"
        btn2.callbackData = "btn2"
        btn2.switchInlineQuery = "switch inline btn2"
        let btn3 = TBInlineKeyboardButton()
        btn3.text =  "Btn3"
        btn3.callbackData = "btn3"
        
        article3.replyKeyboardMarkup = TBInlineKeyboardMarkup(buttons: [[btn1, btn2], [btn3]])
        
        let answerInlineRequest = TBAnswerInlineQueryRequest(inlineRequestId: inlineQuery.id, results: [article1, article2, article3], switchPMText: "Go PM", switchPMParameter: "/info")
        do {
            try self.bot.sendRequest(request: answerInlineRequest, completion: { (response) in
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

