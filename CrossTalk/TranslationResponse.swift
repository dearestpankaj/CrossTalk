//
//  TranslationResponse.swift
//  CrossTalk
//
//  Created by Pankaj Sachdeva on 17/08/20.
//  Copyright © 2020 Pankaj Sachdeva. All rights reserved.
//

import Foundation

struct TranslationResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case languageCode = "lang", translations = "text"
    }
    let languageCode: String
    let translations: [String]
}
