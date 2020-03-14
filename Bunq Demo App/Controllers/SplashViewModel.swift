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
        do {
            let (privateKey, publicKey) = try CC.RSA.generateKeyPair(2048)
            self.keyPairs = KeyPairs(publicKey: SwKeyConvert.PublicKey.derToPKCS8PEM(publicKey), privateKey: SwKeyConvert.PrivateKey.derToPKCS1PEM(privateKey))
        } catch {
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
extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
}
