//
//  SessionModel.swift
//  Bunq Demo App
//
//  Created by Emre on 18.01.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation

struct DeviceServerResponseModel: Decodable {
    let id: Int

    enum CodingKeys: String, CodingKey {
        case data = "Response"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseArray = try container.decode([Response].self, forKey: .data)
        
        id = responseArray[0].id!.id
    }
}

struct DeviceServerRequestModel: Encodable {
    let description: String
    let permittedIps: [String]
    let secret: String
        
    enum CodingKeys: String, CodingKey {
        case secret = "secret"
        case permittedIps = "permitted_ips"
        case description = "description"
    }
}

struct SessionRequestModel: Encodable {
    let secret: String
        
    enum CodingKeys: String, CodingKey {
        case secret = "secret"
    }
}
