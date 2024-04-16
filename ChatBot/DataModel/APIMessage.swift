//
//  APIMessage.swift
//  ChatBot
//
//  Created by Daming Wang on 4/9/24.
//

import Foundation

struct APIMessage: Codable, Hashable {
    let role: String
    let content: String
}
