//
//  BunqErrorModel.swift
//  Bunq Demo App
//
//  Created by Emre on 18.01.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation

struct BunqError: Decodable, Error {
    let errorDescription: String
    let errorDescriptionTranslated: String
    
    private struct BunqErrorDecoderModel: Decodable {
        let errorDescription: String
        let errorDescriptionTranslated: String
        
        enum CodingKeys: String, CodingKey {
            case errorDescription = "error_description"
            case errorDescriptionTranslated = "error_description_translated"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case response = "Error"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseArray = try container.decode([BunqErrorDecoderModel].self, forKey: .response)
        errorDescription = responseArray[0].errorDescription
        errorDescriptionTranslated = responseArray[0].errorDescriptionTranslated
    }
    
}

