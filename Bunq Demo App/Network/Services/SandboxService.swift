//
//  SandboxService.swift
//  Bunq Demo App
//
//  Created by Emre on 1.12.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import PromiseKit
class SandboxService {
    
    /*
      First Network Request
    */
    static func createsandboxUser() -> Promise<SandBoxUserModel> {
        let router = ServiceRouter(method: .post, path: "/v1/sandbox-user")
        return Promise { seal in
            ServiceCaller.performRequest(route: router) { ( result: Result<SandBoxUserModel>) in
                switch result {
                case .error(let error):
                    //NOTE: Do any additional error handling here
                    return seal.reject(error)
                case .success(let input):
                    return seal.fulfill(input)
                }
            }
        }
    }
    
    /*
     Second Network Request
    */
    static func initializeClient(publicKey: String) -> Promise<InstallationModel> {
        let param:[String:Any] = ["client_public_key" :"\(publicKey)"]
        let jsonData = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        // here "jsonData" is the dictionary encoded in JSON data
        let router = ServiceRouter(method: .post, path: "/v1/installation",parameters: jsonData)
        return Promise { seal in
            ServiceCaller.performRequest(route: router) { (result: Result<InstallationModel>) in
                switch result {
                case .error(let error):
                    //NOTE: Do any additional error handling here
                    return seal.reject(error)
                case .success(let input):
                    return seal.fulfill(input)
                }
            }
        }
    }
    
    /*
     Third  Network Request
    */
    static func deviceServerServiceCaller(authKey:String, apiKey: String,privaKey: String) -> Promise<DeviceServerResponseModel> {
        let deviceServerModel = DeviceServerRequestModel(description: "Postman", permittedIps: ["*"], secret: apiKey)
        let router = ServiceRouter(method: .post, path: "/v1/device-server",parameters: deviceServerModel.getJSONData()!,authKey: authKey,hasSignature: true,privateKey: privaKey,apiKey: apiKey)
        return Promise { seal in
            ServiceCaller.performRequest(route: router) { (result: Result<DeviceServerResponseModel>) in
                switch result {
                case .error(let error):
                    //NOTE: Do any additional error handling here
                    return seal.reject(error)
                case .success(let input):
                    return seal.fulfill(input)
                }
            }
        }
    }

    /*
     Last Network Request For App Initialization
     */
    static func sessionServiceCaller(authKey:String, apiKey: String,privaKey: String) -> Promise<UserModel> {
        let deviceServerModel = SessionRequestModel(secret: apiKey)
        let router = ServiceRouter(method: .post, path: "/v1/session-server",parameters: deviceServerModel.getJSONData()!,authKey: authKey,hasSignature: true,privateKey: privaKey,apiKey: apiKey)
        return Promise { seal in
            ServiceCaller.performRequest(route: router) { (result: Result<UserModel>) in
                switch result {
                case .error(let error):
                    //NOTE: Do any additional error handling here
                    return seal.reject(error)
                case .success(let input):
                    return seal.fulfill(input)
                }
            }
        }
    }
    
}
