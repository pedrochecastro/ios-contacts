//
//  FakeFactory.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 24/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//
import Foundation



final class MockFactoryImpl : ContactFactory {
  
  //Faking contacts with this property
  private var fakeContacts: [Contact] = []
  
  let mockError: ContactFactoryError? = nil

  
  func getContacts(completionHandler: @escaping (Result<[Contact], Error>) -> Void) {
   // Error
    if let mockError = mockError  {
      completionHandler(.failure(mockError.localizedDescription))
      return
    }
    // Code with delay from Network, CoreData, FileSystem... (Mock 2 seconds delay)
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
      
      // Get the data parsing...
      // No contacts
      completionHandler(.success(self.fakeContacts))
    }
  }
  
  func add(contact: Contact, completionHandler: (Result<Bool, Error>) -> Void) {
    if let _ = mockError  {
      completionHandler(.failure(ContactFactoryError.insertError(message:"Insert Error")))
      return
    }
    if  fakeContacts.contains(contact) {
      completionHandler(.failure(ContactFactoryError.duplicated(message: "Duplicated contact")))
      return
    }
    
    fakeContacts.append(contact)
    completionHandler(.success(true))
  }
  
  func delete(contact: Contact, completionHandler: (Result<Bool, Error>) -> Void) {
    guard let i = fakeContacts.firstIndex(of: contact) else {
      completionHandler(.failure(ContactFactoryError.notFound(message: "Contact was't found")))
      return}
    fakeContacts.remove(at: i)
    completionHandler(.success(true))
  }
  
  func update(contact: Contact, dataToUpdate: Contact, completionHandler: (Result<Bool, Error>) -> Void) {
    delete(contact: contact) { result in
      switch result {
      case .success:
        add(contact: dataToUpdate) { result in
          switch result {
          case .success:
            completionHandler(.success(true))
          case .failure(let error):
            completionHandler(.failure(error.localizedDescription))
          }
        }
      case .failure(let error):
        completionHandler(.failure(error.localizedDescription))
      }
    }
  }
  
  func contains(contact: Contact) -> Bool {
        return fakeContacts.contains(contact)
  }

}
