//
//  ResponseModel.swift
//  networkLayerProject
//
//  Created by Emre Önder on 3/9/19.
//  Copyright © 2019 Emre. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
