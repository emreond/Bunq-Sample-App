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
    let dailyLimit: Decimal
    let dailyLimitCurrency: String
    
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
        case dailyLimit = "daily_limit_without_confirmation_login"
        case value = "value"
        case currency = "currency"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.created = try container.decode(String.self, forKey: .created)
        self.updated = try container.decode(String.self, forKey: .updated)
        self.status = try container.decode(String.self, forKey: .status)
        self.subStatus = try container.decode(String.self, forKey: .subStatus)
        self.publicuuid = try container.decode(String.self, forKey: .publicuuid)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.publicNickName = try container.decode(String.self, forKey: .publicNickName)
        self.language = try container.decode(String.self, forKey: .language)
        self.region = try container.decode(String.self, forKey: .region)
        self.sessionTimeOut = try container.decode(Int.self, forKey: .sessionTimeOut)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.legalName = try container.decode(String.self, forKey: .legalName)
        self.gender = try container.decode(String.self, forKey: .gender)
        
        let subCont = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .dailyLimit)
        self.dailyLimitCurrency = try subCont.decode(String.self, forKey: .currency)
        let dailyLimitStr = try subCont.decode(String.self, forKey: .value)
        //Handle Error
        self.dailyLimit = Decimal(string: dailyLimitStr)!
    }
}
