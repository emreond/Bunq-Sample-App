//
//  MainViewModel.swift
//  Bunq Demo App
//
//  Created by Emre on 7.03.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation

class MainViewModel {
    
    private var userModel: UserModel
    private var userBankAccount: MonetaryAccountBankModel
    var alias: String {
        get {
            return "Hey " + userModel.userModel.displayName + "!"
        }
    }
    
    var balance: String {
        get {
            return "10 EUR"
        }
    }
    
    var dailyLimit: String {
        get {
            return "\(userModel.userModel.dailyLimit) \(userModel.userModel.dailyLimitCurrency)"
        }
    }
    
    var iban: String {
        get {
            return userBankAccount.alias.first(where: { $0.type == "IBAN" })?.value ?? ""
        }
    }
    
    var accountBalance: String {
        get {
            return "\(userBankAccount.balance.value) \(userBankAccount.balance.currency)"
        }
    }
    
    var description: String {
        get {
            return userBankAccount.description
        }
    }
    
    init(userModel: UserModel, account: MonetaryAccountBankModel) {
        self.userModel = userModel
        self.userBankAccount = account
    }
    
}
