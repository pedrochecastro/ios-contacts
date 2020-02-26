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
  var indexedContactsFiltered :[String:[Contact]] = [:]
  var filter: String?
  var updateSection = false
  var deleteSection = false
  
  
  init(_ repository: ContactFactory) {
    self.repository = repository
    mapToDictionary(contacts: repository.contacts)
  }
  
  // MARK: - Private functions
  
  private func mapToDictionary(contacts: [Contact])  {
    
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
  
  private func retrieveIndexedContact(words: String) -> [Contact] {
    return indexedContacts.reduce([Contact]()) {
      return $0 + $1.value
    }
      .filter {$0.name.contains(words) }
  }
  
 
  
  // MARK: - Public functions
  
  public func sectionsTitlesHeader() -> [String] {

//    self.indexedContactsFiltered = self.indexedContacts
    if let filter = filter {
          let contactsFounded = retrieveIndexedContact(words: filter)
          if contactsFounded.isEmpty {
            indexedContactsFiltered = [:]
          } else {
            indexedContactsFiltered = Dictionary(grouping: contactsFounded) { String($0.name.first!) }
          }
       return Array(indexedContactsFiltered.keys).sorted(by: <)
    }
    return Array(indexedContacts.keys).sorted(by: <)
   
  }
  
  
  public func getSectionTitle(by section: Int) -> String {
    return sectionsTitlesHeader()[section]
  }

  public func getContactList(by section: Int) -> [Contact] {

    let key = sectionsTitlesHeader()[section]
    if var contacts = indexedContacts[key] {
      if let filter = filter {
        let contactsFiltered = contacts.filter { $0.name.contains(filter) }
        // Add contacts filtered to dictionary!!!
        indexedContactsFiltered[key] = indexedContactsFiltered[key] ?? [Contact]() + contactsFiltered
        //
        contacts = contactsFiltered
      }
      return contacts
    } else {
      return []
    }
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
    // Remove in repository
    // REVIEW - If I go to repository for some information can bring back some errors!
    repository?.delete(contact: contact)
    
    // Update the view
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
  
  public func add(contact: Contact) {
    // Add to Repository
    // REVIEW - If I go to repository for some information can bring back some errors!
      repository?.add(contact: contact)
    // Update the view
      insertIndexed(contact: contact)
  }
  
  public func update(contact: Contact, editedContact:Contact) {
    remove(contact: contact)
    add(contact: editedContact)
  }
  
  public func containsIndexedContact(with text: String) -> Bool {
    return retrieveIndexedContact(words: text).count > 0
  }
  
  
  public func removeFilter() {
    filter = nil
    self.indexedContactsFiltered = [:]
  }
}

