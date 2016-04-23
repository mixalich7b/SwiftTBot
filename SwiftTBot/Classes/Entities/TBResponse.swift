//
//  TBResponse.swift
//  SwiftTBot
//
//  Created by Тупицин Константин on 23.04.16.
//  Copyright © 2016 mixalich7b. All rights reserved.
//

import Foundation

public class TBResponse<T: TBEntity> {
    public let isOk: Bool
    public let responseEntities: [T]?
    
    init(isOk: Bool, responseEntities: [T]?) {
        self.isOk = isOk
        self.responseEntities = responseEntities
    }
}
