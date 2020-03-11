//
//  ListMoneyAccounts.swift
//  Bunq Demo App
//
//  Created by Emre on 7.03.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation
import PromiseKit

class ListMoneyAccounts {
    
    /*
     First Network Request
     */
    static func getMoneyAccounts(token: String,userId: Int) -> Promise<MonetaryAccountBankModel> {
        let router = ServiceRouter(method: .get, path: "/v1/user/\(userId)/monetary-account",authKey: token)
        return Promise { seal in
            ServiceCaller.performRequest(route: router) { ( result: Result<MonetaryAccountBankModelParser>) in
                switch result {
                case .error(let error):
                    //NOTE: Do any additional error handling here
                    return seal.reject(error)
                case .success(let input):
                    return seal.fulfill(input.account)
                }
            }
        }
    }
}
