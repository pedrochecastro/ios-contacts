//
//  Contact.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 10/09/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

class Contact : NSObject {
    
    var name: String
    var phoneNumber: String
    var contactImage: UIImage?
  
  
  override init() {
    name = ""
    phoneNumber = ""
  }
    
    init(name: String, phoneNumber: String = "") {
        self.name = name
        self.phoneNumber = phoneNumber
    }
}

class ContactList {
    
    var contactsDB: [String:[Contact]] = [:]
    var indexedContacts: [String:[Contact]] = [:]
    var contacts: [Contact] = []

    var updateSection = false
    var deleteSection = false
  
    init() {}
    
    init(_ contacts: [Contact]) {
      
        self.contacts = contacts
        let aToZ = (0..<26).map({String(UnicodeScalar("A".unicodeScalars.first!.value + $0) ?? "😡")})
        
        aToZ.forEach {
            self.indexedContacts[$0] = [Contact]()
        }
        
        contacts.forEach {
            add(contact: $0)
            updateSection = false
        }
      
      self.contactsDB = self.indexedContacts
      
    }
  
     private func mapToDictionary(contacts: [Contact])  {
        let aToZ = (0..<26).map({String(UnicodeScalar("A".unicodeScalars.first!.value + $0) ?? "😡")})
  
        aToZ.forEach {
        self.indexedContacts[$0] = [Contact]()
        }
  
        contacts.forEach {
        add(contact: $0)
        updateSection = false
        }
    }
    
    
    
    public func sectionsTitlesHeader() -> [String] {
        let filtered = indexedContacts.filter { !$0.value.isEmpty }
        return Array(filtered.keys).sorted(by: <)
    }
    
    
    public func getSectionTitle(by section: Int) -> String {
        return sectionsTitlesHeader()[section]
    }
    
    public func getContactList(by section: Int) -> [Contact] {
        
        let key = sectionsTitlesHeader()[section]
        
        if let contacts = indexedContacts[key] {
            return contacts
        } else { return [] }
    }
    
    public func getContact(by indexpath: IndexPath) -> Contact {
        let contacts = getContactList(by: indexpath.section)
        return contacts[indexpath.row]
    }
  
    public func getContacts(by name: String) -> [Contact] {
      return contacts.filter { $0.name.contains(name) }
    }
    
    public func getIndexPath(from contact: Contact) -> IndexPath {
        //key
         let key = String(contact.name.prefix(1))
        //Section A..Z
        let section = (sectionsTitlesHeader().firstIndex(of: key))!
        //Row
            let contacts = self.indexedContacts[key]!
            let row = contacts.firstIndex(of: contact)!
            return IndexPath(row: row, section: section)
    }
        
    public func add(contact: Contact) {
        let key = String(contact.name.prefix(1))
        if !sectionsTitlesHeader().contains(key) {
            updateSection = true
        }
        
        if var contacts = indexedContacts[key] {
            contacts.append(contact)
            self.indexedContacts[key] = contacts.sorted()
        }
    }
    
    public func remove(contact: Contact) {
        //key
        let key = String(contact.name.prefix(1))

        var contacts = self.indexedContacts[key]!
        if contacts.count == 1 {
            deleteSection = true
        }
        let index = contacts.firstIndex(of: contact)!
        contacts.remove(at: index)
        self.indexedContacts[key] = contacts
    }
  
    public func setFilter(txt: String) -> Bool{
      
      let contactsFounded = getContacts(by: txt)
      if contactsFounded.isEmpty {
        self.indexedContacts = [:]
        return false
      } else {
        mapToDictionary(contacts: contactsFounded)
        return true
      }
    }
  
    public func removeFilter() {
        self.indexedContacts = contactsDB
    }
}

extension Contact : Comparable {
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
    
    
}
