//
//  Repository.swift
//
//  Created by Pedro Sánchez Castro on 16/7/17.
//  Copyright © 2017 Pedro Sánchez Castro. All rights reserved.
//


enum RepositorySource {
  case fake
  case coredata
}

final class Repository {
  
  static let shared =  Repository(source: RepositorySource.coredata)
  var contactsSource: ContactFactory
  
  
  init(source: RepositorySource) {
    switch source {
    case .fake:
      self.contactsSource = FakeFactory()
    case .coredata:
      self.contactsSource = CoreDataFactory()
    }
  }

}

protocol ContactFactory {
  
  var contacts : [Contact] {get set}
  func add(contact: Contact)
  func delete(contact: Contact)
  func update(contact: Contact, newContact: Contact)
  func contains(contact: Contact) -> Bool
  
}
