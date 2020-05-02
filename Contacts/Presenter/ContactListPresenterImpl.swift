
//  ContactListDataPresenter.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 03/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import Foundation

protocol ContactListPresenter: class {
  // Input
  func numberOfSections() -> Int
  func numberOfRowsIn(section: Int) -> Int
  func titleForHeaderIn(section: Int) -> String
  func contactsBy(section: Int) -> [Contact]
  func contactsBy(indexPaths: [IndexPath]) -> [Contact]
  func add(contact: Contact, completion: (Result<Bool, Error>) -> Void)
  func remove(contact: Contact, completion:(Result<Int, Error>) -> Void)
  func update(contact: Contact,newContact:Contact, completion: (Result<Int,Error>) -> Void)
  // Output: Check this!
  func didAdded(contact: Contact)
  func didChange(completion: @escaping () -> Void)
}

class ContactListPresenterImpl: ContactListPresenter {
  
  // MARK: - TypeDef
  typealias ContactIndexed = [String:[Contact]]
  
  // MARK: - Constants & Var
  
  let repository : Repository
  var completionChange: (() -> Void)?
  var indexedContacts: ContactIndexed = [:] {
    didSet {
      guard let completionChange = completionChange else {return}
      completionChange()
    }
  }
  var indexedContactsFiltered : ContactIndexed = [:]
  var filter: String?
  var updateSection = false
  var deleteSection = false
  
  
  init(_ repository: Repository) {
    self.repository = repository
  }
  
  // MARK: - Protocol implementation
  func numberOfSections() -> Int {
    return indexedContacts.keys.count
  }
  
  func numberOfRowsIn(section: Int) -> Int {
    return contactsBy(section: section).count
  }
  
  func titleForHeaderIn(section: Int) -> String {
    let keysSorted = Array(indexedContacts.keys).sorted(by: <)
    let titleForHeader = keysSorted[section]
    return titleForHeader
  }
  
  func contactsBy(section: Int) -> [Contact] {
    let keysSorted = Array(indexedContacts.keys).sorted(by: <)
    let key = keysSorted[section]
    guard let contactsInSection = indexedContacts[key] else { return [] } //Error must be handle
    return contactsInSection
  }
  
  func contactsBy(indexPaths: [IndexPath]) -> [Contact] {
    let keysSorted = Array(indexedContacts.keys).sorted(by: <)
    var contacts: [Contact] = []
    indexPaths.forEach { indexPath in
      let key = keysSorted[indexPath.section]
      guard let contactsInSection = indexedContacts[key] else { return } //Error must be handle
      let contact = contactsInSection[indexPath.row]
      contacts.append(contact)
    }
    return contacts
  }
  
  func add(contact: Contact, completion: (Result<Bool, Error>)-> Void) {
    repository.contactFactory.add(contact: contact) { result in
      switch result {
      case .success(let ok):
        completion(.success(ok))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func remove(contact: Contact, completion: (Result<Int, Error>) -> Void) {
    repository.contactFactory.delete(contact: contact) { result in
      switch result {
      case .success:
        completion(.success(200))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func update(contact: Contact, newContact: Contact, completion: (Result<Int, Error>) -> Void) {
    repository.contactFactory.update(contact: contact,dataToUpdate: newContact) { result in
         switch result {
         case .success:
           completion(.success(200))
         case .failure(let error):
           completion(.failure(error))
         }
       }
    
  }
  
  func didChange(completion: @escaping () -> Void) {
    self.completionChange = completion
  }
  
  
  func didAdded(contact: Contact) {
    self.insertIndexed(contact: contact)
  }
  
  // MARK: - Private functions
  
  
  private func mapToDictionary(contacts: [Contact]) -> ContactIndexed {
    
    var ci = ContactIndexed()
    
    contacts.forEach {
      insertIndexed(contact: $0)
      updateSection = false
    }
    
    func insertIndexed(contact: Contact) {
      let key = String(contact.name.prefix(1))
      if !sectionsTitlesHeader().contains(key) {
        updateSection = true
      }
      
      if var contacts = ci[key] {
        contacts.append(contact)
        ci[key] = contacts.sorted()
      }
      else {
        var contacts = [Contact]()
        contacts.append(contact)
        ci[key] = contacts
      }
    }
    
    return ci
  }
  
  
  
  private func retrieveIndexedContact(words: String) -> [Contact] {
    return indexedContacts.reduce([Contact]()) {
      return $0 + $1.value
    }
    .filter {$0.name.contains(words) }
  }
  
  
  // MARK: - Public functions ⚠️ Change
  
  public func sectionsTitlesHeader() -> [String] {
    
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
    return getContactList().filter { $0.name.contains(name) }
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
  
  // MARK: - Repository
  public func getContactList() -> [Contact] {
    //TODO thows error and control
    var contacts: [Contact] = []
    repository.contactFactory.getContacts { result in
      // TODO return data inside a closure
      switch result {
      case .success(let data):
        contacts = data
      case.failure(let error):
        print(error.localizedDescription)
      }
    }
    return contacts
  }
  
  
  public func add(contact: Contact) {
    ////     Add to Repository with error control Fail
    //    repository.contactFactory.add(contact: contact) { result in
    //      switch result {
    //      case .success:
    //        insertIndexed(contact: contact)
    //      case .failure(let error):
    //        print(error.localizedDescription)
    //      }
    //    }
    //
    
  }
  
  public func remove(contact: Contact) {
    // Remove in repository with error control
    repository.contactFactory.delete(contact: contact) { result in
      switch result {
      case .success:
        // Update presenter
        //key
        let key = String(contact.name.prefix(1))
        
        var contacts = self.indexedContacts[key]!
        if contacts.count == 1 {
          deleteSection = true
          indexedContacts.removeValue(forKey: key)
        } else {
          let index = contacts.firstIndex(of: contact)!
          contacts.remove(at: index)
          self.indexedContacts[key] = contacts
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    
  }
  
  
  public func update(contact: Contact, editedContact:Contact) {
    repository.contactFactory.update(contact: contact, dataToUpdate: editedContact) { result in
      switch result {
      case .success:
        // Update presenter
        //key
        let key = String(contact.name.prefix(1))
        
        var contacts = self.indexedContacts[key]!
        if contacts.count == 1 {
          deleteSection = true
          indexedContacts.removeValue(forKey: key)
        } else {
          let index = contacts.firstIndex(of: contact)!
          contacts.remove(at: index)
          self.indexedContacts[key] = contacts
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  public func containsIndexedContact(with text: String) -> Bool {
    return retrieveIndexedContact(words: text).count > 0
  }
  
  
  public func removeFilter() {
    filter = nil
    self.indexedContactsFiltered = [:]
  }
  
  public func insertIndexed(contact: Contact) {
    
    let key = String(contact.name.prefix(1))
    if !sectionsTitlesHeader().contains(key) {
      updateSection = true
    }
    
    if var contacts = indexedContacts[key] {
      contacts.append(contact)
      indexedContacts[key] = contacts.sorted()
    }
    else {
      var contacts = [Contact]()
      contacts.append(contact)
      indexedContacts[key] = contacts
    }
  }
}

