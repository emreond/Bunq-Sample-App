//
//  ServiceErrorHandler.swift
//  networkLayerProject
//
//  Created by Emre Onder on 3/9/19.
//  Copyright © 2019 Emre Onder. All rights reserved.
//

import Foundation
import UIKit

class ServiceError: Error {
    let message: String
    let title: String
    let type: ErrorType
    
    enum ErrorType {
        case ServiceError
        case DataError
        case FatalError
        case ParseError
    }
    
    private init(title: String, message: String, type: ErrorType) {
        self.message = message
        self.title = title
        self.type = type
    }
    
    
    static func handle(error: Error, statusCode: Int, showPopup: Bool = true ) -> ServiceError {
        let messageText = "There is an unexpected error. Please Try Again!"
        //TODO: Handle different statuscode responses in this class
        let customError = ServiceError(title: "Bunq Error", message: messageText, type: ServiceError.ErrorType.ServiceError)
        if showPopup {
            //Handle error popups here.
        }
        return customError
    }
    
    static func handleParseError() -> ServiceError {
        let messageText = "There is an unexpected error. Please Try Again!"
        //TODO: Handle different statuscode responses in this class
        let customError = ServiceError(title:  "Bunq Error", message: messageText, type: ServiceError.ErrorType.ParseError)
        return customError
    }
}
