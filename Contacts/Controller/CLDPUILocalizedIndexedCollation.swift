//
//  ContactListDataPresenterUILocalizedIndexedCollation.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 26/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import UIKit

class CLDPUILocalizedIndexedCollation {
  
  // MARK: - Constants & Var
  
  let repository : ContactFactory?
//  var indexedContacts: [String:[Contact]] = [:]
//  var indexedContactsFiltered : [String:[Contact]] = [:]
  var filter: String?
  var updateSection = false
  var deleteSection = false
  
  // UILocalizedIndexedCollation
  let collation = UILocalizedIndexedCollation.current()
  var sections: [[AnyObject]] = []
  var objects: [CollationIndexable] = [] {
    didSet {
      populateSection()
    }
  }
  
  
  init(_ repository: ContactFactory) {
    self.repository = repository
    objects = repository.contacts
    populateSection()
  }
  
  // MARK: - Private functions
  
 private func populateSection() {
    sections = Array(repeating: [], count: collation.sectionTitles.count)
    let selector = #selector(getter: CollationIndexable.collationString)
    
    let sortedObjects = collation.sortedArray(from: objects, collationStringSelector: selector)
    for object in sortedObjects {
      let sectionNumber = collation.section(for: object, collationStringSelector: selector)
      sections[sectionNumber].append(object as AnyObject)
    }
  }
  
  private func retrieveIndexedContact(words: String) -> [Contact] {
    return objects.filter {($0 as! Contact).name.contains(words) } as! [Contact]
  }
  
  
  
  // MARK: - Public functions
  
  public func sectionsTitlesHeader() -> [String] {

//    if let filter = filter {
//      let contactsFounded = retrieveIndexedContact(words: filter)
//      if contactsFounded.isEmpty {
//        indexedContactsFiltered = [:]
//      } else {
//        indexedContactsFiltered = Dictionary(grouping: contactsFounded) { String($0.name.first!) }
//      }
//      return Array(indexedContactsFiltered.keys).sorted(by: <)
//    }
//    return Array(indexedContacts.keys).sorted(by: <)
    return collation.sectionTitles

  }
  
  
  public func getSectionTitle(by section: Int) -> String {
    return  collation.sectionIndexTitles[section]
  }
  
  public func getContactList(by section: Int) -> [Contact] {
    let contacts = sections[section]
    return sections[section] as! [Contact]
  }
  

  
  public func getContact(by indexpath: IndexPath) -> Contact {
//    let contacts = getContactList(by: indexpath.section)
//    return contacts[indexpath.row]
    return sections[indexpath.section][indexpath.row] as! Contact
  }
  
//  public func getContacts(by name: String) -> [Contact] {
//    return (repository?.contacts.filter { $0.name.contains(name) })!
//  }
  
  public func getIndexPath(from contact: Contact) -> IndexPath {

    let selector = #selector(getter: CollationIndexable.collationString)
    let section = collation.section(for: contact, collationStringSelector: selector)
    let contacts = sections[section] as! [Contact]
    let row = contacts.firstIndex(of: contact)
    return IndexPath(row: row!, section: section)
    
  }
  
  public func add(contact: Contact) {
    // Add to Repository
    repository?.add(contact: contact)
    // REVIEW - If I go to repository for some information can bring back some errors!
//    insertIndexed(contact: contact)
    let selector = #selector(getter: CollationIndexable.collationString)
    let section = collation.section(for: contact, collationStringSelector: selector)
    var contacts = sections[section] as! [Contact]
    contacts.append(contact)
    sections[section] = contacts
    
  }
  
  public func remove(contact: Contact) {
    // Remove in repository
    // REVIEW - If I go to repository for some information can bring back some errors!
    repository?.delete(contact: contact)
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
//    self.indexedContactsFiltered = [:]
  }
}


