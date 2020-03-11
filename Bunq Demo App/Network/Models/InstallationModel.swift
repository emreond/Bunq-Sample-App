//
//  InitializationModel.swift
//  Bunq Demo App
//
//  Created by Emre on 5.01.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation

struct InstallationModel: Decodable {
    let id: Int
    let serverPublicKey: String
    let token: Token
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseArray = try container.decode([Response].self, forKey: .response)
        
        //Be sure that array order is accurate everytime. If not, array can be for looped.
        if let id = responseArray[0].id, let token = responseArray[1].token, let key = responseArray[2].serverPublicKey {
            self.id = id.id
            self.serverPublicKey = key.serverPublicKey
            self.token = token
        } else {
            let error = ServiceError.handleParseError()
            throw error
        }
    }
}

struct Token: Decodable {
    let token: String
    let updated: String
    let created: String
    let id: Int
}

struct ID: Decodable {
    let id: Int
}

 struct ServerPublicKey: Decodable {
    let serverPublicKey: String
    enum CodingKeys: String, CodingKey {
        case serverPublicKey = "server_public_key"
    }
}
