//
//  JSCommunicationHandler.swift
//  Bunq Demo App
//
//  Created by Emre on 18.01.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation
import JavaScriptCore

class JSCommunicationHandler {
    private let context = JSContext()
    
    init() {
        context?.exceptionHandler = {context, exception in
            if let exception = exception {
                print(exception.toString()!)
            }
        }
    }
    
    func callFunction<T>(functionName:String, withData dataObject:Codable?, type:T.Type) -> JSValue? where T:Codable {
        var dataString = ""
        if let unwrappedDataObject = dataObject,let string = getString(fromObject: unwrappedDataObject, type:type) {
            dataString = string
            let functionString = functionName + "(\(dataString))"
            let result = context?.evaluateScript(functionString)
            return result
        } else {
            let functionString = functionName
            let result = context?.evaluateScript(functionString)
            return result
        }
    }
    
    func loadSourceFile(atUrl url:URL) {
        guard let stringFromUrl = try? String(contentsOf: url) else {return}
        context?.evaluateScript(stringFromUrl)
    }
    
    func evaluateJavaScript(_ jsString:String) -> JSValue? {
        context?.evaluateScript(jsString)
    }
    
    func setObject(object:Any, withName:String) {
        context?.setObject(object, forKeyedSubscript: withName as NSCopying & NSObjectProtocol)
    }
}

extension JSCommunicationHandler {
    private func getString<T>(fromObject jsonObject:Codable, type:T.Type) -> String? where T:Codable {
        let encoder = JSONEncoder()
        guard let dataObject = jsonObject as? T,
            let data = try? encoder.encode(dataObject),
            let string = String(data:data, encoding:.utf8) else  {
                return nil
        }
        return string
    }
}
