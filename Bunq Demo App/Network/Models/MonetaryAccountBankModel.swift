//
//  MonetaryAccountBankModel.swift
//  Bunq Demo App
//
//  Created by Emre on 7.03.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation

struct MonetaryAccountBankModelParser: Decodable {
    let account: MonetaryAccountBankModel
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseArray = try container.decode([Response].self, forKey: .response)
        
        //Be sure that array order is accurate everytime. If not, array can be for looped.
        guard let unwrappedModel = responseArray[0].monetaryAccountModel else { throw ServiceError.handleParseError() }
        self.account = unwrappedModel
    }
}
struct MonetaryAccountBankModel: Decodable {
    //TOOD: Change this to Date object
    let createdDate: String
    let balance: Balance
    let alias: [Alias]
    let description: String
    enum CodingKeys: String, CodingKey {
        case createdDate = "created"
        case balance = "balance"
        case alias = "alias"
        case description = "description" 
    }
}

struct Alias: Decodable {
    let type: String
    let value: String
    let name: String
}
struct Balance: Decodable {
    let currency: String
    let value: String
}
