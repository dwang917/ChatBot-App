//
//  RequestBody.swift
//  ChatBot
//
//  Created by Daming Wang on 4/9/24.
//

import Foundation

struct RequestBody: Codable {
    var messages: [APIMessage]
    let model: String
}
