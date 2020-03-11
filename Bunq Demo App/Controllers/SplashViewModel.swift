//
//  SplashViewModel.swift
//  Bunq Demo App
//
//  Created by Emre on 26.01.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation
import PromiseKit

protocol SplashViewProtocol: AnyObject {
    func updateProgress(with val: Float)
}
class SplashViewModel {
    
    private var keyPairs: KeyPairs
    private var sandboxUserModel: SandBoxUserModel?
    private var userModel: UserModel?
    private var initModel: InstallationModel?
    private var userAccount: MonetaryAccountBankModel?
    
    weak var delegate: SplashViewProtocol?
    
    init?(del: SplashViewProtocol) {
        self.delegate = del
        if let jsSourcePath = Bundle.main.url(forResource: "rsakeygenerator", withExtension: "js") {
            let jsHandler = JSCommunicationHandler()
            jsHandler.loadSourceFile(atUrl: jsSourcePath)
            let returnObject = jsHandler.evaluateJavaScript("myKeyFunction()")!
            if let dict = returnObject.toObject() as? [String:Any], let pubKey = dict["publicKey"] as? String, let privateKey = dict["privateKey"] as? String {
                let keyPairs = KeyPairs(publicKey: pubKey, privateKey: privateKey)
                self.keyPairs = keyPairs
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func callService(completionHandler: @escaping (Result<UserModel>) -> Void) {
        SandboxService.createsandboxUser().then { userModel -> Promise<InstallationModel> in
            self.sandboxUserModel = userModel
            self.delegate?.updateProgress(with: 30)
            return SandboxService.initializeClient(publicKey: self.keyPairs.publicKey)
        }.then { initModel -> Promise<DeviceServerResponseModel> in
            self.initModel = initModel
            self.delegate?.updateProgress(with: 60)
            if let unwrappedUserModel = self.sandboxUserModel {
                return SandboxService.deviceServerServiceCaller(authKey: initModel.token.token,apiKey:unwrappedUserModel.apiKey,privaKey: self.keyPairs.privateKey)
            }
            throw ServiceError.handleParseError()
        }.then { serverResponseModel -> Promise<UserModel> in
            self.delegate?.updateProgress(with: 90)
            if let unwrappedInitModel = self.initModel, let unwrappedUserModel = self.sandboxUserModel {
                return SandboxService.sessionServiceCaller(authKey: unwrappedInitModel.token.token, apiKey: unwrappedUserModel.apiKey, privaKey: self.keyPairs.privateKey)
            }
            throw ServiceError.handleParseError()
        }.then { userModel -> Promise<MonetaryAccountBankModel>  in
            self.userModel = userModel
            return ListMoneyAccounts.getMoneyAccounts(token: userModel.token.token,userId: userModel.userModel.id)
        }.done { account in
            self.userAccount = account
            self.delegate?.updateProgress(with: 100)
            completionHandler(Result.success(self.userModel!))
        }.catch { error in
            completionHandler(Result.error(error))
        }
    }
    
    func getUserModel() -> UserModel? {
        return self.userModel
    }
    func getBankAccount() -> MonetaryAccountBankModel? {
        return self.userAccount
    }
    
}
