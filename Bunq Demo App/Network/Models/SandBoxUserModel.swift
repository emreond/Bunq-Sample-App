//
//  InitializeServiceModels.swift
//  Bunq Demo App
//
//  Created by Emre on 1.12.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation


import Foundation

struct SandBoxUserModel: Decodable {
    let apiKey: String
    
    enum CodingKeys: String, CodingKey {
        case data = "Response"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseArray = try container.decode([SandBoxUser].self, forKey: .data)
        
        apiKey = responseArray[0].apiKey
    }
}
fileprivate struct SandBoxUser: Decodable {
    let apiKey: String
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case topContainer = "ApiKey"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let subContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .topContainer)
        apiKey = try subContainer.decode(String.self, forKey: .apiKey)
    }
}
