//
//  ServiceCaller.swift
//  networkLayerProject
//
//  Created by Emre Önder on 3/9/19.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class ServiceCaller {
    static func performRequest<T: Decodable>(route: ServiceRouter, completion: @escaping (Result<T>) -> Void) {
        CustomServiceManager.instance.sessionManager.request(route).responseJSON(completionHandler: { result in
            if let error = result.error {
                if let unwrappedResponse = result.response {
                    let error = ServiceError.handle(error: error, statusCode: unwrappedResponse.statusCode)
                    completion(.error(error))
                } else {
                    let error = ServiceError.handle(error: error, statusCode: error._code)
                    completion(.error(error))
                }

            } else if let data = result.data {
                do {
                    let output = try newJSONDecoder().decode(T.self, from: data)
                    completion(.success(output))
                } catch let error {
                    print(error)
                    do {
                        let errorOutput = try newJSONDecoder().decode(BunqError.self, from: data)
                        completion(.error(errorOutput))
                    } catch {
                        print("Can't catch the error")
                    }
                }
            }
        })
    }
}
