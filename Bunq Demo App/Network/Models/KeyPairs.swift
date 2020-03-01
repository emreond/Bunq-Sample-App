//
//  KeyModel.swift
//  Bunq Demo App
//
//  Created by Emre on 25.01.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation

struct KeyPairs: Codable {
    let publicKey: String
    let privateKey: String
    
    enum CodingKeys: String, CodingKey {
        case publicKey = "publicKey"
        case privateKey = "privateKey"
    }
}
