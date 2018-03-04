//
//  Employee.swift
//  RaiseMan
//
//  Created by Nate Chandler on 9/1/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Foundation

@objc class Employee: NSObject {
    @objc dynamic var name: String? = "New Employee"
    @objc dynamic var raise: Float = 0.05
 
    override func validateValue(_ ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey inKey: String) throws {
        let raiseNumber = ioValue.pointee // "memory" is now "pointee" in Swift 3
        if inKey == "raise" && raiseNumber == nil {
            let domain = "UserInputValidationErrorDomain"
            let code = 0
            let userInfo = [NSLocalizedDescriptionKey : "An employee's raise must be a number."]
            throw NSError(domain: domain, code: code, userInfo: userInfo)
        }
    }
}
