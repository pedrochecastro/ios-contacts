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
    
    var contactList: [String:[Contact]] = [:]
    var updateSection = false
    var deleteSection = false
    
    init() {}
    
    init(_ contacts: [Contact]) {
        let aToZ = (0..<26).map({String(UnicodeScalar("A".unicodeScalars.first!.value + $0) ?? "😡")})
        
        aToZ.forEach {
            contactList[$0] = [Contact]()
        }
        
        contacts.forEach {
            add(contact: $0)
            updateSection = false
        }
        
    }
    
    public func sectionsTitlesHeader() -> [String] {
        let filtered = contactList.filter { !$0.value.isEmpty }
        return Array(filtered.keys).sorted(by: <)
    }
    
    
    public func getSectionTitle(by section: Int) -> String {
        return sectionsTitlesHeader()[section]
    }
    
    public func getContactList(by section: Int) -> [Contact] {
        
        let key = sectionsTitlesHeader()[section]
        
        if let contacts = contactList[key] {
            return contacts
        } else { return [] }
    }
    
    public func getContact(by indexpath: IndexPath) -> Contact {
        let contacts = getContactList(by: indexpath.section)
        return contacts[indexpath.row]
    }
    
    public func getIndexPath(from contact: Contact) -> IndexPath {
        //key
         let key = String(contact.name.prefix(1))
        //Section A..Z
        let section = (sectionsTitlesHeader().firstIndex(of: key))!
        //Row
            let contacts = contactList[key]!
            let row = contacts.firstIndex(of: contact)!
            return IndexPath(row: row, section: section)
    }
        
    public func add(contact: Contact) {
        let key = String(contact.name.prefix(1))
        if !sectionsTitlesHeader().contains(key) {
            updateSection = true
        }
        
        if var contacts = contactList[key] {
            contacts.append(contact)
            contactList[key] = contacts.sorted()
        }
    }
    
    public func remove(contact: Contact) {
        //key
        let key = String(contact.name.prefix(1))

        var contacts = contactList[key]!
        if contacts.count == 1 {
            deleteSection = true
        }
        let index = contacts.firstIndex(of: contact)!
        contacts.remove(at: index)
        contactList[key] = contacts
    }
}

extension Contact : Comparable {
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
    
    
}
