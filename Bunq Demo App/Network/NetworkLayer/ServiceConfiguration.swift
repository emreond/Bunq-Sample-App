//
//  ServiceConstants.swift
//  networkLayerProject
//
//  Created by Emre Önder on 3/9/19.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import Alamofire

protocol ServiceConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get set }
    var path: String { get set }
    var parameters: Data? { get set }
}
