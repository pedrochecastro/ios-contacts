//
//  Validators.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 11/11/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import Foundation

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

enum ValidatorType {
    case name
    case phone
    case requiredField(field: String)
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
            case .name: return NameValidator()
            case .phone: return PhoneValidator()
            case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        }
    }
}

struct NameValidator : ValidatorConvertible{
    // Only letters
    func validated(_ value: String) throws -> String {
     //Regex Pattern
      return ""
    }
    
}

struct PhoneValidator: ValidatorConvertible {
    // Only 9 numbers
    func validated(_ value: String) throws -> String {
        //Regex pattern
     return ""
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError("Required field " + fieldName)
        }
        return value
    }
    
    
}
