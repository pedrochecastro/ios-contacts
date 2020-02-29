//
//  Contact.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 10/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

class Contact {
    
    var name: String
    var phoneNumber: String
    var contactImage: UIImage?
  
  
//    override init() {
//      name = ""
//      phoneNumber = ""
//    }
  
    init() {
        name = ""
        phoneNumber = ""
      }
  
    init(name: String, phoneNumber: String = "") {
        self.name = name
        self.phoneNumber = phoneNumber
    }
  
//    override func isEqual(_ object: Any?) -> Bool {
//      guard let contact = object as? Contact else { return false }
//      return self.name == contact.name
//    }
}

extension Contact : Comparable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
      return lhs.name == rhs.name
    }
  
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
}
