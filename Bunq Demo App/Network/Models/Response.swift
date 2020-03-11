//
//  ResponseModel.swift
//  Bunq Demo App
//
//  Created by Emre on 7.03.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation

struct Response: Decodable {
    let id: ID?
    let token: Token?
    let serverPublicKey: ServerPublicKey?
    let userPerson: UserPerson?
    let monetaryAccountModel: MonetaryAccountBankModel?
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case token = "Token"
        case serverPublicKey = "ServerPublicKey"
        case userPerson = "UserPerson"
        case monetaryAccountModel = "MonetaryAccountBank"
    }
}
