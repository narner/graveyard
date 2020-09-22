//
//  GPT-3_Response.swift
//  GPT-3_ScryingKeyboard
//
//  Created by Nick Arner on 8/16/20.
//  Copyright © 2020 Nick Arner. All rights reserved.
//

import Foundation

class Response: Decodable {

    var finish_reason: String
    var index: String
    var logprobs: String
    var text: String

    enum CodingKeys: String, CodingKey {
        case finish_reason
        case index
        case text
        case logprobs
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.finish_reason = try container.decode(String.self, forKey: .finish_reason)
        self.index = try container.decode(String.self, forKey: .index)
        self.logprobs = try container.decode(String.self, forKey: .logprobs)
        self.text = try container.decode(String.self, forKey: .text)
    }
}
