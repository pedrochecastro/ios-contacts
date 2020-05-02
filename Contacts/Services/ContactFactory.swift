//
//  ContactFactory.swift
//  Contacts
//
//  Created by Pedro Sakey on 21/04/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import Foundation

enum ContactFactoryError: Error {
  case unknowed(message: String)
  case duplicated(message: String)
  case insertError(message: String)
  case notFound(message: String)
}

// Factories

protocol ContactFactory {
  func addPresenters(presenters: [ContactListPresenter])
  func getContacts(completionHandler: @escaping (Result<[Contact], Error>) -> Void)
  func add(contact: Contact, requestFrom: ContactListPresenter?, completionHandler: (Result<Bool, Error>) -> Void)
  func delete(contact: Contact,  completionHandler: (Result<Bool, Error>) -> Void)
  func update(contact: Contact, dataToUpdate: Contact, completionHandler: (Result<Bool,Error>) -> Void)
  func contains(contact: Contact) -> Bool  
}

extension ContactFactory {
  func add(contact: Contact, requestFrom: ContactListPresenter? = nil, completionHandler: (Result<Bool, Error>) -> Void) {
    self.add(contact: contact, requestFrom: nil, completionHandler: completionHandler)
  }
}
