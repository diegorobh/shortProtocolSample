//
//  ResponseLogin.swift
//  protocol_test
//
//  Created by diego paredes on 18/11/19.
//  Copyright © 2019 Diego Paredes. All rights reserved.
//

import Foundation
struct ResponseLogin: Decodable {
    
    var token: String
    
    private enum CodingKeys: String, CodingKey {
        case token
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decode(String.self, forKey: .token)
    }
    
}
