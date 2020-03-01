//
//  SplashViewModel.swift
//  Bunq Demo App
//
//  Created by Emre on 26.01.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation
import PromiseKit

protocol SplashViewProtocol {
    func updateProgress(with val: Float)
}
class SplashViewModel {
    
    private var keyPairs: KeyPairs
    private var userModel: SandBoxUserModel?
    private var initModel: InstallationModel?
    
    var delegate: SplashViewProtocol?
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
            self.userModel = userModel
            self.delegate?.updateProgress(with: 30)
            return SandboxService.initializeClient(publicKey: self.keyPairs.publicKey)
        }.then { initModel -> Promise<DeviceServerResponseModel> in
            self.initModel = initModel
            self.delegate?.updateProgress(with: 60)
            if let unwrappedUserModel = self.userModel {
                return SandboxService.deviceServerServiceCaller(authKey: initModel.token.token,apiKey:unwrappedUserModel.apiKey,privaKey: self.keyPairs.privateKey)
            }
            throw ServiceError.handleParseError()
        }.then { serverResponseModel -> Promise<UserModel> in
            self.delegate?.updateProgress(with: 90)
            if let unwrappedInitModel = self.initModel, let unwrappedUserModel = self.userModel {
                return SandboxService.sessionServiceCaller(authKey: unwrappedInitModel.token.token, apiKey: unwrappedUserModel.apiKey, privaKey: self.keyPairs.privateKey)
            }
            throw ServiceError.handleParseError()
        }.done { userModel in
            self.delegate?.updateProgress(with: 100)
            completionHandler(Result.success(userModel))
        }.catch { error in
            completionHandler(Result.error(error))
        }
    }
    
}
