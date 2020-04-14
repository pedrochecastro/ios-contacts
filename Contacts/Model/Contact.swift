//
//  Contact.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 10/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

@objc protocol CollationIndexable {
  @objc var collationString : String { get }
}

class Contact {
    
    var name: String
    var phoneNumber: String
    var contactImage: UIImage?
  
    init() {
        name = ""
        phoneNumber = ""
      }
  
    init(name: String, phoneNumber: String = "") {
        self.name = name
        self.phoneNumber = phoneNumber
    }

}

extension Contact : Comparable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
      return lhs.name == rhs.name
//              && lhs.phoneNumber == rhs.phoneNumber
    }
  
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
}

extension Contact : CollationIndexable {
  
  @objc var collationString : String {
    return name
  }
}
