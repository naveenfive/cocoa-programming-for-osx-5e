//
//  Employee.swift
//  RaiseMan
//
//  Created by Nick Teissler on 2/16/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation

@objc class Employee: NSObject {
    @objc dynamic var name: String? = "New Employee"
    @objc dynamic var raise: Float = 0.05
    
    override func validateValue(_ ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey inKey: String) throws {
        let raiseNumber = ioValue.pointee
        if inKey == "raise" && raiseNumber == nil {
            let domain = "UserInputValidationErrorDomain"
            let code = 0
            let userInfo = [NSLocalizedDescriptionKey : "An employee's raise must be a number."]
            throw NSError(domain: domain, code: code, userInfo: userInfo)
        }
    }
    
   
}
