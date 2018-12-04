import Foundation
import SwiftTBot

private let bot = TBot(token: "<your_token>")

bot.on("/start") { "Hello, \($0.from?.firstName ?? $0.chat.firstName ?? "" )"}
    .on("/test") { _ in "It's work"}
    .on("/info") {[weak bot] (message, textReply) in
        do {
            try bot?.sendRequest(TBGetMeRequest(), completion: { (response) in
                if let username = response.responseEntities?.first?.username {
                    textReply.send("\(username)\nhttps://telegram.me/\(username)")
                }
            })
        } catch {
        }
}

let awesomeCommandRegex = try! NSRegularExpression(
    pattern: "^(\\/awesome)\\s([0-9]{1,4})\\s([0-9]{1,4})$",
    options: NSRegularExpression.Options(rawValue: 0)
)
let argsParsingRegex = try! NSRegularExpression(
    pattern: "([0-9]{1,4})",
    options: NSRegularExpression.Options(rawValue: 0)
)
bot.on(awesomeCommandRegex) { (message, matchRange, textReply) in
    guard let text = message.text else {
        return
    }
    
    
    let replyString = argsParsingRegex.matches(
        in: text,
        options: NSRegularExpression.MatchingOptions.reportProgress,
        range: matchRange)
        .reduce("Args: ") { (replyText, checkResult) -> String in
            return replyText + (text as NSString).substring(with: checkResult.range) + ", "
    }
    textReply.send(replyString)
}

bot.onInline(awesomeCommandRegex) { (inlineQuery, range, inlineQueryReply) in
    let article1 = TBInlineQueryResultArticle(
        id: "\(arc4random_uniform(1000))",
        title: "Test title",
        inputMessageContent: TBInputTextMessageContent(messageText: "Test text")
    )
    article1.url = "google.com"
    inlineQueryReply.send([article1])
}


bot.start { (error) in
    print("Bot haven't started, error: \(error?.description ?? "unknown")")
}

private func respondToMessage(_ message: TBMessage) {
    let text = message.text
    let contact = message.contact
    let location = message.location
    
    let replyText = text
        ?? contact.map{"\($0.phoneNumber), \($0.firstName)"}
        ?? location?.debugDescription ?? "Hello!"
    let replyHTML = "<i>\(replyText)</i>\n<a href='http://www.instml.com/'>Instaml</a>";
    
    let keyboard = TBReplyKeyboardMarkup(buttons: [
        [TBKeyboardButton(text: "Contact", requestContact: true)],
        [TBKeyboardButton(text: "Location", requestLocation: true)]
        ]);
    keyboard.selective = true
    keyboard.oneTimeKeyboard = true
    let echoRequest = TBSendMessageRequest(
        chatId: message.chat.id,
        text: replyHTML,
        replyMarkup: keyboard,
        parseMode: .HTML
    )
    do {
        try bot.sendRequest(echoRequest, completion: { (response) in
            if !response.isOk {
                print("API error: \(response.error?.description ?? "unknown")")
            }
        })
    } catch TBError.badRequest {
        print("Bad request")
    } catch {
        print("")
    }
}

private func respondToInlineQuery(_ inlineQuery: TBInlineQuery) {
    let article1 = TBInlineQueryResultArticle(
        id: "\(arc4random_uniform(1000))",
        title: "Test title",
        inputMessageContent: TBInputTextMessageContent(messageText: "Test text")
    )
    article1.url = "google.com"
    let article2 = TBInlineQueryResultArticle(
        id: "\(arc4random_uniform(1000))",
        title: "Awesome article",
        inputMessageContent: TBInputLocationMessageContent(longitude: 98.292905, latitude: 7.817627)
    )
    article2.url = "vk.com"
    
    let btn1 = TBInlineKeyboardButton(text: "Btn1")
    btn1.url = "2ch.hk/b"
    btn1.callbackData = "btn1"
    let btn2 = TBInlineKeyboardButton(text: "Btn2")
    btn2.callbackData = "btn2"
    btn2.switchInlineQuery = "switch inline btn2"
    let btn3 = TBInlineKeyboardButton(text: "Btn3")
    btn3.callbackData = "btn3"
    let replyKeyboardMarkup = TBInlineKeyboardMarkup(buttons: [[btn1, btn2], [btn3]])
    let article3 = TBInlineQueryResultArticle(id: "\(arc4random_uniform(1000))",
        title: "Echo result",
        inputMessageContent: TBInputTextMessageContent(messageText: "Echo: \(inlineQuery.text)"),
        replyKeyboardMarkup: replyKeyboardMarkup
    )
    article3.url = "youtube.com"
    article3.description = "Echo: \(inlineQuery.text),\noffset: \(inlineQuery.offset)"
    
    let answerInlineRequest = TBAnswerInlineQueryRequest(
        inlineRequestId: inlineQuery.id,
        results: [article1, article2, article3]
    )
    answerInlineRequest.switchPMText = "Go PM"
    answerInlineRequest.switchPMParameter = "info"
    answerInlineRequest.cacheTimeSeconds = 5
    do {
        try bot.sendRequest(answerInlineRequest, completion: { (response) in
            if !response.isOk {
                print("API error: \(response.error?.description ?? "unknown")")
            }
        })
    } catch TBError.badRequest {
        print("Bad request")
    } catch {
        print("")
    }
}

let _ = readLine()
bot.stop()
