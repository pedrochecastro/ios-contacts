//
//  ContactListDataPresenter.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 03/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import Foundation

class ContactListDataPresenter {
  
  // MARK: - Constants & Var
  
  let repository : ContactFactory?
  var indexedContacts: [String:[Contact]] = [:]
  var updateSection = false
  var deleteSection = false
  
  
  init(_ repository: ContactFactory) {
    self.repository = repository
    mapToDictionary(contacts: repository.contacts)
    let a = 0
  }
  
  // MARK: - Private functions
  
  private func mapToDictionary(contacts: [Contact])  {
    
//    Constants.aToZ.forEach {
//      self.indexedContacts[$0] = [Contact]()
//    }
    
    contacts.forEach {
      insertIndexed(contact: $0)
      updateSection = false
    }
  }
  
  private func insertIndexed(contact: Contact) {
    let key = String(contact.name.prefix(1))
    if !sectionsTitlesHeader().contains(key) {
      updateSection = true
    }
    
    if var contacts = indexedContacts[key] {
      contacts.append(contact)
      self.indexedContacts[key] = contacts.sorted()
    }
    else {
      var contacts = [Contact]()
      contacts.append(contact)
      indexedContacts[key] = contacts
    }
  }
  
  
  // MARK: - Public functions
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
    return (repository?.contacts.filter { $0.name.contains(name) })!
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
//    self.indexedContacts = contactsDB
  }
}

