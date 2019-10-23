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
    
    var sectionsTitlesHeader = ["B","E","L","S"]
    
    var BcontactList : [Contact] = [Contact(name: "Bill Gates", phoneNumber: "+43987654878"),]
    
    var EcontactList: [Contact] = [Contact(name: "Elon Musk", phoneNumber: "+43987654878"),]
    
    var LcontactListt: [Contact] = [Contact(name: "Larry Page", phoneNumber: "+43987654878"),]
    
    var ScontactList: [Contact] = [Contact(name: "Steve Jobs", phoneNumber: "+43987654878"),
                                   Contact(name: "Sundar Pichay", phoneNumber: "+43987654878")]
   
    
    init() {}
    
    init(_ contacts: [Contact]) {
        let aToZ = (0..<26).map({String(UnicodeScalar("A".unicodeScalars.first!.value + $0) ?? "😡")})
        
        aToZ.forEach {
            contactList[$0] = [Contact]()
        }
        
        contacts.forEach {
            add(contact: $0)
        }
        
    }
    
    
    public func getSectionTitle(by section: Int) -> String {
        return sectionsTitlesHeader[section]
    }
    
    public func getContactList(by section: Int) -> [Contact] {
        
        switch section {
        case 0:
            return BcontactList
        case 1:
            return EcontactList
        case 2:
            return LcontactListt
        case 3:
            return ScontactList
        default:
            return []
        }
    }
    
    public func numberOfSections() -> Int {
        var sections = 0
        contactList.forEach {
            if $0.value.count != 0 {
                sections += 1
            }
        }
        return sections
    }
    
    public func numberOfContacts() -> Int {
        return contactList.values.count
    }
    
    public func add(contact: Contact) {
        let letterKey = String(contact.name.prefix(1))
        if var contactsByKey = contactList[letterKey] {
            contactsByKey.append(contact)
            contactList[letterKey] = contactsByKey
        }
    }
    
    
    
    public func getContact(_ indexPath: IndexPath) -> Contact?{
        print(indexPath)
        
        let contactKeys = sectionTitle()

        if let contacts = contactList[contactKeys[indexPath.section]] {
            return contacts[0]
        }
        return nil
    }
    
    func sectionTitle() -> [String] {
        let filtered = contactList.filter { !$0.value.isEmpty }
        return Array(filtered.keys).sorted(by: <)
    }
    
    func namesBySection(sectionTitle: String) -> [Contact] {
        return contactList[sectionTitle] ?? []
    }
    
    
    public func calculateOffset(letter: String) -> Int{
        let aToZ = (0..<26).map({String(UnicodeScalar("a".unicodeScalars.first!.value + $0) ?? "😡")})
        return (aToZ.firstIndex(of: letter))!
    }
    
   
    
    public func getContactIndexPath(contact: Contact) -> IndexPath? {
        let letterKey = String(contact.name.prefix(1))
        let contacts = contactList[letterKey]!
        let section = 0
        let row = 0
        return  IndexPath(row: row, section: section)
    }
    
//    public func calculateKey(indexpath: IndexPath) -> String {
//        let aToZ = (0..<26).map({String(UnicodeScalar("A".unicodeScalars.first!.value + $0) ?? "😡")})
//        return aToZ[indexpath.section]
//    }

    
//    public func removeContact(contact: Contact ) {
//        let letterKey = String(contact.name.prefix(1))
//        _ = contactList.remove(at index: contactList[letterKey, contact.name])
//    }
    
//    public func edit(contact:Contact, nameEdited: String) {
//        if let index = getContactIndex(contact: contact) {
//            contactList[index].name = nameEdited
//        }
//    }
}

extension Contact : Comparable {
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.name < rhs.name
    }
    
    
}
