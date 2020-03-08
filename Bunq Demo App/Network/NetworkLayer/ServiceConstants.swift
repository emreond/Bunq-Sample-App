//
//  ServiceConstants.swift
//  networkLayerProject
//
//  Created by Emre Önder on 3/9/19.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation
import Alamofire

struct ServiceConstants {
    static let timeoutInterval = 40.0
    static let baseURL = "https://public-api.sandbox.bunq.com"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case BunqLanguage = "X-Bunq-Language"
    case BunqRegion = "X-Bunq-Region"
    case BunqGeolocation = "X-Bunq-Geolocation"
    case BunRequestId = "X-Bunq-Client-Request-Id"
    case cacheControl = "Cache-Control"
    case BunqSignature = "X-Bunq-Client-Signature"
    case BunqAuth = "X-Bunq-Client-Authentication"
    case userAgent = "User-Agent"
}

enum ContentType: String {
    case json = "application/json"
    case geoLocation = "0 0 0 0 000"
    case language = "en_US"
    case cache = "no-cache"
}
