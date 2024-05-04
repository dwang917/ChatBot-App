//
//  RequestBody.swift
//  ChatBot
//
//  Created by Daming Wang on 4/9/24.
//

import Foundation
//source: https://anjalijoshi2426.medium.com/fetch-data-from-nested-json-in-api-in-swift-629e67fe8269
struct RequestBody: Codable {
    var messages: [APIMessage]
    let model: String
}

