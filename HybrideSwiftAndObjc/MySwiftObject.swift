//
//  MySwiftObject.swift
//  HybrideSwiftAndObjc
//
//  Created by zgpeace on 2019/2/13.
//  Copyright © 2019 zgpeace. All rights reserved.
//

import Foundation

class MySwiftObject: NSObject {
    
    @objc var someProperty: String = "Some Initializer Val"
    
    override init() {}
    
    @objc func someFunction(someArg:AnyObject) -> String {
        let returnVal = "You sent me \(someArg)"
        return returnVal
    }
}
