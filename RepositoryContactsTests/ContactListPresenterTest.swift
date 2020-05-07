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
  var contactListPresenter2: ContactListPresenter!
  var contacts : [Contact] = []
  
  override func setUp() {
    self.contactFactory = MockFactoryImpl()
    self.repository = Repository(contactFactory: self.contactFactory)
    self.contactListPresenter = ContactListPresenterImpl(repository)
    self.contactListPresenter2 = ContactListPresenterImpl(repository)
    self.contactFactory.addPresenters(presenters: [contactListPresenter,contactListPresenter2])
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
    
    contactListPresenter.add(contact: contact1) { result  in
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
    
    let exp1 = self.expectation(description: "Add contact1")
    let contact1 = Contact(name: "Abigail", phoneNumber: "123123123")
    
    let exp2 = self.expectation(description: "Add contact 2")
    let contact2 = Contact(name: "Caroline", phoneNumber: "123123123")
    
    let exp3 = self.expectation(description: "Add contact 3")
    let contact3 = Contact(name: "Celia", phoneNumber: "123123123")
    
    
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
    
    contactListPresenter.add(contact: contact3) { result in
         switch result {
         case .success:
           XCTAssert(contactListPresenter.numberOfSections() == 2, "Numbers of section must be 0")
           self.contacts.append(contact1)
         case .failure:
           XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
         }
         exp3.fulfill()
       }
    
      wait(for: [exp1,exp2,exp3], timeout: 1)
    
    let indexPath = IndexPath(row: 1, section: 1)
    let contactsExpected = [contact3]
    XCTAssert(contactListPresenter.contactsBy(indexPaths: [indexPath]) == contactsExpected, "Differents contacts we expect \(contact3.name).")
    
  }
  
  func testGetContacts() {
//    Create a repository without adding presenters
    let contactFactory = MockFactoryImpl()
    let repository = Repository(contactFactory: contactFactory)
    let contactListPresenter = ContactListPresenterImpl(repository)
    
    // Add 2 contacts to empty repository
    let contact = Contact(name: "Abigail", phoneNumber: "123123123")
    let contact2 = Contact(name: "Ana", phoneNumber: "123123123")
    let exp1 = self.expectation(description: "Result complete. Contact Added.")
    let exp2 = self.expectation(description: "Result complete. Contact Added")
    let exp3 = self.expectation(description: "Result complete. Get Result from repository")
    repository.contactFactory.add(contact: contact) { result in
      exp1.fulfill()
      switch result {
      case .success:
        print("RepositoryTest contact added")
      case .failure:
        print("Error")
      }
    }
    
    repository.contactFactory.add(contact: contact2) { result in
      exp2.fulfill()
      switch result {
      case .success:
        print("RepositoryTest contact added")
      case .failure:
        print("Error")
      }
    }
    wait(for: [exp1,exp2], timeout: 2)
    repository.contactFactory.addPresenters(presenters: [contactListPresenter])
   //So presenter must be updated with 2 contacts from repository
    contactListPresenter.getContacts { result in
      exp3.fulfill()
      switch result {
      case .success:
        print("ok")
      case.failure:
        print("error")
      }
    }
    wait(for: [exp3], timeout: 2)
    XCTAssert(contactListPresenter.contactsBy(section: 0).count == 2, "Presenter was Updated with 2 contacts from repository")
  }
  
  func testAddContact() {
     let exp = self.expectation(description: "Contact was added or error")
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
    let exp1 = self.expectation(description: "Contact was added or Error")
    let contact1 = Contact(name: "Abigail", phoneNumber: "123123123")
    
    let exp2 = self.expectation(description: "Contact was removed or Error")
    
    
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
    
    contactListPresenter.remove(contact: contact1) { result in
      XCTAssert(self.contacts.count == 1, "Numbers of Contacts must be one")
      switch result {
      case .success:
        self.contacts.removeAll { $0 == contact1 }
      case .failure:
        print("Error removing")
      }
      exp2.fulfill()
    }
    
    wait(for: [exp1,exp2], timeout: 1)
    
    XCTAssert(self.contacts.count == 0, "Numbers of Contacts must be 0")
  }
  
  func testUpdateContact() {
    let exp1 = self.expectation(description: "Contact was added or Error")
    let contact1 = Contact(name: "Abigail", phoneNumber: "123123123")
    let newData = Contact(name: "Abigail", phoneNumber: "777777777")
    
    let exp2 = self.expectation(description: "Contact was updteda or Error")
    
    
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
    
    contactListPresenter.update(contact: contact1, newContact: newData) { result in
            XCTAssert(self.contacts.count == 1, "Numbers of Contacts must be one")
            switch result {
            case .success:
              self.contacts.removeAll { $0 == contact1 }
              self.contacts.append(newData)
            case .failure:
              print("Error removing")
            }
            exp2.fulfill()
    }
    
    wait(for: [exp1,exp2], timeout: 1)
    
    XCTAssert(self.contacts[0].phoneNumber == "777777777", "Wrong new number")
  }
  
  func testClosureMulticastingDelegation() {
    
    let exp1 = self.expectation(description: "Contact was added or error")
//    let exp2 = self.expectation(description: "IndexedContacts Change")
    let contact = Contact(name: "Abigail", phoneNumber: "123123123")
    
    contactListPresenter.add(contact: contact) { result in
      switch result {
      case .success:
        XCTAssert(contactListPresenter.numberOfSections() == 1, "Numbers of section must be 0")
        self.contacts.append(contact)
      case .failure:
        XCTAssert(contactListPresenter.numberOfSections() == 0, "Numbers of section must be 0")
      }
      exp1.fulfill()
    }
    wait(for: [exp1], timeout: 1)
    XCTAssert(contactListPresenter2.numberOfSections() == 1, "Presenter 2 wasn't updated")
    
  }
}
