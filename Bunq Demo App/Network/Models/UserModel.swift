//
//  UserModel.swift
//  Bunq Demo App
//
//  Created by Emre on 26.01.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation

struct UserModel: Decodable {
    let id: Int
    let userModel: UserPerson
    let token: Token
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseArray = try container.decode([Response].self, forKey: .response)
        
        //Be sure that array order is accurate everytime. If not, array can be for looped.
        if let id = responseArray[0].id, let token = responseArray[1].token, let userModel = responseArray[2].userPerson {
            self.id = id.id
            self.userModel = userModel
            self.token = token
        } else {
            let error = ServiceError.handleParseError()
            throw error
        }
    }
}

struct UserPerson: Decodable {
    let id: Int
    let created: String
    let updated: String
    let status: String
    let subStatus: String
    let publicuuid: String
    let displayName: String
    let publicNickName: String
    let language: String
    let region: String
    let sessionTimeOut: Int
    let firstName: String
    let lastName: String
    let legalName: String
    let gender: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case created = "created"
        case updated = "updated"
        case status = "status"
        case subStatus = "sub_status"
        case publicuuid = "public_uuid"
        case displayName = "display_name"
        case publicNickName = "public_nick_name"
        case language = "language"
        case region = "region"
        case sessionTimeOut = "session_timeout"
        case firstName = "first_name"
        case lastName = "last_name"
        case legalName = "legal_name"
        case gender = "gender"
    }
}
