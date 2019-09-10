//
//  Contact.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 10/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import Foundation

class Contact {
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

class ContactList {
    
    var contactList: [Contact] = []
    private let contactsNames  =
        ["Steve Jobs",
         "Bill Gates",
         "Sundar Pichay",
         "Larry Page",
         "Elon Musk",
        ]
    
    init() {
        contactsNames.forEach {
            contactList.append(Contact(name: $0))
        }
        
    }
    
    public func numberOfContacts() -> Int {
        return contactList.count
    }
    
    public func getContactBy(position: Int) -> Contact{
        return contactList[position]
    }
}