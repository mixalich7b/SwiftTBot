//
//  TBAnswerInlineQueryRequest.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 03.05.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import ObjectMapper

public class TBAnswerInlineQueryRequest<Res: TBEntity>: TBRequest<Res> {
    override internal func getMethod() -> String {
        return "answerInlineQuery"
    }
    
    public var id: String = ""
    public var results: [TBInlineQueryResult] = []
    public var cacheLifetime: Int?
    public var isPersonal: Bool?
    public var paginationOffset: String?
    public var switchPMText: String?
    public var switchPMParameter: String?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["inline_query_id"]
        
        results <- map["results"]
        cacheLifetime <- map["cache_time"]
        isPersonal <- map["is_personal"]
        paginationOffset <- map["next_offset"]
        switchPMText <- map["switch_pm_text"]
        switchPMParameter <- map["switch_pm_parameter"]
    }
    
    override public init() {
        super.init()
    }
    
    convenience public init(inlineRequestId: String, results: [TBInlineQueryResult]) {
        self.init()
        self.id = inlineRequestId
        self.results = results
    }
    
    convenience public init(inlineRequestId: String, results: [TBInlineQueryResult], switchPMText: String, switchPMParameter: String) {
        self.init()
        self.id = inlineRequestId
        self.results = results
        self.switchPMText = switchPMText
        self.switchPMParameter = switchPMParameter
    }
}
