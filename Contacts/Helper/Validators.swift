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
    case name(repository: ContactFactory?)
    case phone
    case requiredField(field: String)
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .name(let repository): return NameValidator(repository: repository!)
        case .phone: return PhoneValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
      }
    }
}

struct NameValidator : ValidatorConvertible{
  
    let repository: ContactFactory?
  
    init() {
      self.repository = nil
    }
  
    init(repository: ContactFactory) {
      self.repository = repository
    }
    // Only letters and whitespaces
    func validated(_ value: String) throws -> String {
        guard value.count >= 3 else {
            throw ValidationError("Username must contain more than three characters" )
        }
        guard value.count < 18 else {
            throw ValidationError("Username shoudn't conain more than 18 characters" )
        }
        
        do {
            // If Regex match we find a no number character
            let a = try NSRegularExpression(pattern: "[^A-Za-z\\s]+", options: .caseInsensitive).firstMatch(in: value, options:[], range: NSRange(location: 0, length: value.count))
            if a != nil {
                throw ValidationError("Invalid contact name, username should not contain numbers or special characters")
          } } catch {
            throw ValidationError("Invalid Pattern")
        }
          if let repository = repository {
              if repository.contains(contact: Contact(name: value)) {
                throw ValidationError ("Duplicated Contact")
              }
          }
        
        return value
    }
    
}

struct PhoneValidator: ValidatorConvertible {
    // Only 9 numbers
    func validated(_ value: String) throws -> String {
        guard value.count == 9 else {
            throw ValidationError("Phone must contain 9 digits" )
        }
        do {
            if try NSRegularExpression(pattern: "[0-9]").firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                 throw ValidationError("Phone must contain 9 digits" )
            }
        } catch {
             throw ValidationError("Phone must contain 9 digits" )
        }
        return value
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

