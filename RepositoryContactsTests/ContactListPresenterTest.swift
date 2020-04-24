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
  var contacts : [Contact] = []
  
  override func setUp() {
    self.contactFactory = MockFactoryImpl()
    self.repository = Repository(contactFactory: self.contactFactory)
    self.contactListPresenter = ContactListPresenterImpl(repository)
  }

  
  func testNumberOfSections() {
    XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
  }
  
  func testNumberOfRowsIn() {
    let exp1 = self.expectation(description: "Update with closure")
    let contact1 = Contact(name: "Abigail", phoneNumber: "123123123")
    
    let exp2 = self.expectation(description: "Update with closure")
    let contact2 = Contact(name: "Antoine", phoneNumber: "123123123")
    
    contactListPresenter.add(contact: contact1) { result in
      switch result {
      case .success:
        XCTAssert(contactListPresenter.numberOfSections() == 1, "Numbers of section must be 0")
        self.contacts.append(contact1)
      case .failure:
        XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
      }
      exp1.fulfill()
    }
    
    contactListPresenter.add(contact: contact2) { result in
      switch result {
      case .success:
        XCTAssert(contactListPresenter.numberOfSections() == 1, "Numbers of section must be 0")
        self.contacts.append(contact1)
      case .failure:
        XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
      }
      exp2.fulfill()
      
      wait(for: [exp1,exp2], timeout: 1)
      
      XCTAssert(contactListPresenter.numberOfRowsIn(section: 0) == 2)
    }
    
    
  }
  
  func testTitleForHeaderIn() {
    let exp1 = self.expectation(description: "Contact added")
    let exp2 = self.expectation(description: "Contact added")
    let contact1 = Contact(name: "Bogan", phoneNumber: "123123123")
    let contact2 = Contact(name: "Antoine", phoneNumber: "123123123")
    
    contactListPresenter.add(contact: contact1) { result in
      switch result {
      case .success:
        XCTAssert(contactListPresenter.numberOfSections() == 1, "Numbers of section must be 0")
        self.contacts.append(contact1)
      case .failure:
        XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
      }
      exp1.fulfill()
    }
    
    contactListPresenter.add(contact: contact2) { result in
      switch result {
      case .success:
        XCTAssert(contactListPresenter.numberOfSections() == 2, "Numbers of section must be 0")
        self.contacts.append(contact1)
      case .failure:
        XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
      }
      exp2.fulfill()
    }
    
     wait(for: [exp1,exp2], timeout: 1)
    
    XCTAssert(contactListPresenter.titleForHeaderIn(section: 0) == "A")
    
  }
  
  func testContactsBySection() {
    let exp1 = self.expectation(description: "Update with closure")
    let contact1 = Contact(name: "Abigail", phoneNumber: "123123123")
    
    let exp2 = self.expectation(description: "Update with closure")
    let contact2 = Contact(name: "Antoine", phoneNumber: "123123123")
    
    let contactsExpectdInSection = [contact1,contact2]
    
    contactListPresenter.add(contact: contact1) { result in
      switch result {
      case .success:
        XCTAssert(contactListPresenter.numberOfSections() == 1, "Numbers of section must be 0")
        self.contacts.append(contact1)
      case .failure:
        XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
      }
      exp1.fulfill()
    }
    
    contactListPresenter.add(contact: contact2) { result in
      switch result {
      case .success:
        XCTAssert(contactListPresenter.numberOfSections() == 1, "Numbers of section must be 0")
        self.contacts.append(contact1)
      case .failure:
        XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
      }
      exp2.fulfill()
    }
    
    wait(for: [exp1,exp2], timeout: 1)
    
    XCTAssert(contactListPresenter.contactsBy(section: 0) == contactsExpectdInSection)
  }
  
  func testContactsByIndexPath() {
    
  }
  
  func testAddContact() {
     let exp = self.expectation(description: "Update with closure")
     let contact = Contact(name: "Abigail", phoneNumber: "123123123")
     contactListPresenter.add(contact: contact) { result in
       switch result {
       case .success:
         XCTAssert(contactListPresenter.numberOfSections() == 1, "Numbers of section must be 0")
         self.contacts.append(contact)
       case .failure:
         XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
       }
       exp.fulfill()
     }
     
     waitForExpectations(timeout: 1, handler: nil)
     
     XCTAssert(contacts.count == 1, "Numbers of Contacts should be updated to 1")
   }
  
  func testRemoveContact() {
    
  }
  
  func testUpdateContact() {
    
  }

}
