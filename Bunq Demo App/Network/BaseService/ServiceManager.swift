//
//  ServiceManager.swift
//  networkLayerProject
//
//  Created by Emre Önder on 3/9/19.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import Alamofire

struct CustomServiceManager {
    static let instance = CustomServiceManager()
    var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: nil
        )
        return manager
    }()
}
