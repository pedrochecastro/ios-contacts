//
//  Contact.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 10/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import Foundation

class Contact : NSObject {
    
    var name: String
    var phoneNumber: String
    
    init(name: String, phoneNumber: String = "") {
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

class ContactList {
    
    var contactList: [Contact] = []
    private var contactsNames  =
        [Contact(name: "Steve Jobs", phoneNumber: "+43987654878"),
         Contact(name: "Bill Gates", phoneNumber: "+43987654878"),
         Contact(name: "Sundar Pichay", phoneNumber: "+43987654878"),
         Contact(name: "Larry Page", phoneNumber: "+43987654878"),
         Contact(name: "Elon Musk", phoneNumber: "+43987654878")
        ]
    
    init() {
        contactsNames.forEach {
            contactList.append(Contact(name: $0.name, phoneNumber: $0.phoneNumber))
            
        }
        
    }
    public func add(contact: Contact) {
        contactList.append(contact)
    }
    
    public func numberOfContacts() -> Int {
        return contactList.count
    }
    
    public func getContact(index: Int) -> Contact{
        return contactList[index]
    }
    
    public func getContactIndex(contact: Contact) -> Int? {
       return  contactList.firstIndex(of: contact)
    }
    
    public func removeContact(index: Int) {
        contactList.remove(at: index)
    }
    
    public func edit(contact:Contact, nameEdited: String) {
        if let index = getContactIndex(contact: contact) {
            contactList[index].name = nameEdited
        }
    }
}
