//
//  ContactListPresenterTest.swift
//  RepositoryContactsTests
//
//  Created by Pedro Sakey on 01/05/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactListPresenterTest: XCTestCase {
  
  var contactFactory: ContactFactory!
  var repository: Repository!
  var contactListPresenter: ContactListPresenter!
  
  override func setUp() {
    self.contactFactory = MockFactoryImpl()
    self.repository = Repository(contactFactory: self.contactFactory)
    self.contactListPresenter = ContactListPresenterImpl(repository)
  }

  func testAddContact() {

  
  func testNumberOfSections() {
    XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
  }
  
  func testNumberOfRowsIn() {
    
  }
  
  func testTitleForHeaderIn() {
    
  }
  
  func testContactsBySection() {
    
  }
  
  func testContactsByIndexPath() {
    
  }
  
  // Helper functions
  func addContactToRepository() {
    let contact = Contact(name: "Abigail", phoneNumber: "123123123")
    repository.contactFactory.add(contact: contact) { result in
      switch result {
      case .success:
        print("Repositorytests contact added")
      case .failure:
        print("Error")
        XCTAssert(false, "There was a promblem adding to repository")
      }
    }
  }

}
