
//  ContactListDataPresenter.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 03/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import Foundation

protocol ContactListPresenter: class {
  // Presenter Owner <--> Presenter
  func numberOfSections() -> Int
  func numberOfRowsIn(section: Int) -> Int
  func sectionIndexTitles() -> [String]?
  func titleForHeaderIn(section: Int) -> String
  func contactsBy(section: Int) -> [Contact]
  func indexPathFrom(contact: Contact) -> IndexPath
  func contactsBy(indexPaths: [IndexPath]) -> [Contact]
  // Presenter <--> Repository
  func getContacts(completion: @escaping (Result<SuccessCode, Error>) -> Void)
  func add(contact: Contact, completion: (Result<SuccessCode, Error>) -> Void)
  func remove(contact: Contact, completion:(Result<Int, Error>) -> Void)
  func update(contact: Contact,newContact:Contact, completion: (Result<Int,Error>) -> Void)
  // Updates
  func didFinishAdding(contact: Contact)
  func didFinishGetting(contacts: [Contact])
  func didFinishDeleting(contact: Contact)
  func didFinishEditing(contact: Contact,newData: Contact)
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
  
  func sectionIndexTitles() -> [String]? {
    // Filter pending
    return Array(indexedContacts.keys).sorted(by: <)
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

  func indexPathFrom(contact: Contact) -> IndexPath {
    //key
    let key = String(contact.name.prefix(1))
    //Section A..Z
    guard let sectionTitlesHeader = sectionIndexTitles() else { return IndexPath()}
    let section = (sectionTitlesHeader.firstIndex(of: key))!
    //Row
    let contacts = self.indexedContacts[key]!
    let row = contacts.firstIndex(of: contact)!
    return IndexPath(row: row, section: section)
  }
  
  func getContacts(completion: @escaping (Result<SuccessCode, Error>) -> Void) {
    repository.contactFactory.getContacts { result in
      switch result {
      case .success(let contacts):
        self.didFinishGetting(contacts: contacts)
        completion(.success(.added))
      case .failure:
        print ("Error")
      }
    }
  }
  
  func add(contact: Contact, completion: (Result<SuccessCode, Error>)-> Void) {
    repository.contactFactory.add(contact: contact) { result in
      switch result {
      case .success:
        completion(.success(.added))
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
  
  func didFinishAdding(contact: Contact) {
    self.insertIndexed(contact: contact)
  }
  
  func didFinishGetting(contacts: [Contact]) {
    self.indexedContacts = self.mapToDictionary(contacts: contacts)
  }
  
  func didChange(completion: @escaping () -> Void) {
     self.completionChange = completion
   }
  
  func didFinishEditing(contact: Contact, newData: Contact) {
    self.removeIndexed(contact: contact)
    self.insertIndexed(contact: newData)
  }
  
  func didFinishDeleting(contact: Contact) {
    self.removeIndexed(contact: contact)
  }
  
  // MARK: - Not in the protocol find a better approach for filtering 🔎
   public func removeFilter() {
      filter = nil
      self.indexedContactsFiltered = [:]
    }
  
   public func containsIndexedContact(with text: String) -> Bool {
      return retrieveIndexedContact(words: text).count > 0
    }
  
  // MARK: - Private functions
    
  private func insertIndexed(contact: Contact) {
    let key = String(contact.name.prefix(1))
    guard let sectionIndexTitles = sectionIndexTitles() else {return}
    if !sectionIndexTitles.contains(key) {
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
  
  private func removeIndexed(contact: Contact) {
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
  }
  
  
  private func mapToDictionary(contacts: [Contact]) -> ContactIndexed {

    var ci = ContactIndexed()

    contacts.forEach {
      insertIndexed(contact: $0)
      updateSection = false
    }

    func insertIndexed(contact: Contact) {
      let key = String(contact.name.prefix(1))
      guard let sectionIndexTitles = sectionIndexTitles() else {return}
      if !sectionIndexTitles.contains(key) {
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

}
