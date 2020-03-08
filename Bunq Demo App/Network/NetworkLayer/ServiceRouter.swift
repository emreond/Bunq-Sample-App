//
//  ServiceRouter.swift
//  networkLayerProject
//
//  Created by Emre Önder on 3/9/19.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class ServiceRouter: ServiceConfiguration {
    var method: HTTPMethod
    
    var path: String
    
    // MARK: - Parameters
    
    var parameters: Data?
    
    var timeoutSec: Double?
    
    var token: String?
    
    var authKey: String?
    
    var hasSignature: Bool?
    
    var privateKey: String?
    
    var apiKey: String?
    
    init(method: HTTPMethod, path: String, timeoutSec: Double) {
        self.method = method
        self.path = path
        self.timeoutSec = timeoutSec
    }
    
    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
    }
    
    init(method: HTTPMethod, path: String,authKey: String) {
        self.method = method
        self.path = path
        self.authKey = authKey
    }
    
    init(method: HTTPMethod, path: String, parameters: Data, timeoutSec: Double) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.timeoutSec = timeoutSec
    }
    
    init(method: HTTPMethod, path: String, parameters: Data) {
        self.method = method
        self.path = path
        self.parameters = parameters
    }
    
    init(method: HTTPMethod, path: String, parameters: Data,authKey: String, hasSignature: Bool,privateKey: String,apiKey: String) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.authKey = authKey
        self.hasSignature = hasSignature
        self.privateKey = privateKey
        self.apiKey = apiKey
    }
    // MARK: - URLRequestConvertible
    
    // Func to create request and include tokens, headers etc...
    func asURLRequest() throws -> URLRequest {
        let url: URL =  URL(string: ServiceConstants.baseURL)!
        var urlRequest = URLRequest(url: URL(string: url.absoluteString + path)!)
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(ContentType.language.rawValue, forHTTPHeaderField: HTTPHeaderField.BunqRegion.rawValue)
        urlRequest.setValue(ContentType.language.rawValue, forHTTPHeaderField: HTTPHeaderField.BunqLanguage.rawValue)
        urlRequest.setValue(ContentType.geoLocation.rawValue, forHTTPHeaderField: HTTPHeaderField.BunqGeolocation.rawValue)
        urlRequest.setValue(ContentType.cache.rawValue, forHTTPHeaderField: HTTPHeaderField.cacheControl.rawValue)
        urlRequest.setValue(randomRequestId(length: 20), forHTTPHeaderField: HTTPHeaderField.BunRequestId.rawValue)
        urlRequest.setValue("postman", forHTTPHeaderField: HTTPHeaderField.userAgent.rawValue)
        
        if let timeOut = timeoutSec {
            urlRequest.timeoutInterval = timeOut
        } else {
            // Request Timeout
            urlRequest.timeoutInterval = ServiceConstants.timeoutInterval
        }
        
        if let unwrappedAuthKey = authKey {
            urlRequest.setValue(unwrappedAuthKey, forHTTPHeaderField: HTTPHeaderField.BunqAuth.rawValue)
        }
        // Parameters
        if let parameters = parameters {
            urlRequest.httpBody = parameters
            // urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        if let hasSignature = hasSignature, hasSignature == true, let unwrappedPriKey = privateKey, let unwrappedApiKey = self.apiKey {
            let bodyStr = """
            {"secret":"\(unwrappedApiKey)"}
            """
            let signatureVal = getSignature(body: bodyStr,privateKey: unwrappedPriKey)
            urlRequest.setValue(signatureVal, forHTTPHeaderField: HTTPHeaderField.BunqSignature.rawValue)
        }
        
        return urlRequest
    }
    
    private func randomRequestId(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    private func getSignature(body: String,privateKey: String) -> String {
        if let jsSourcePath = Bundle.main.url(forResource: "signature", withExtension: "js") {
            let jsHandler = JSCommunicationHandler()
            jsHandler.loadSourceFile(atUrl: jsSourcePath)
            let dataToSign = body
            jsHandler.setObject(object: dataToSign, withName: "data_to_sign")
            jsHandler.setObject(object: privateKey, withName: "key")
            let returnObject = jsHandler.evaluateJavaScript("mySignatureFunction()")!
            return returnObject.toString()
        } else {
            return ""
        }
    }
}
