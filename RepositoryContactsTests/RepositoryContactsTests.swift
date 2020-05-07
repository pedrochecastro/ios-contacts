//
//  RepositoryContactsTests.swift
//  RepositoryContactsTests
//
//  Created by Pedro Sakey on 23/04/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import XCTest
@testable import Contacts

class RepositoryContactsTests: XCTestCase {
  
  var contactFactory: ContactFactory!
  var repository: Repository!
  
  var resData: (Result<[Contact],Error>)? = nil

  override func setUp() {
    self.contactFactory = MockFactoryImpl()
    self.repository = Repository(contactFactory: self.contactFactory)
  }

  override class func tearDown() {
    
  }
  
  func testRepositoryIsEmpty() {
    
    let expectation = self.expectation(description: "Result has Contacts")
    repository.contactFactory.getContacts { result in
      self.resData = result
      expectation.fulfill()
      switch(result) {
      case .success(let contacts):
        XCTAssertTrue(contacts.isEmpty, "Is not empty \(contacts.count)")
      case .failure(let error):
        XCTAssertNotNil(error, "Error")
      }
    }
    // Wait for the expectation to be fullfilled, or time out
    // after 5 seconds. This is where the test runner will pause.
    waitForExpectations(timeout: 2, handler: nil)
    
    XCTAssertNotNil(resData, "No data recived")
  }
  
  
  func testAddContactToRepository() {
    
    let contact = Contact(name: "Abigail", phoneNumber: "123123123")
    let exp1 = self.expectation(description: "Result complete. Contact Added.")
    let exp2 = self.expectation(description: "Result complete. There are contacts")


   
    
    repository.contactFactory.add(contact: contact) { result in
      switch result {
      case .success:
        print("RepositoryTest contact added")
        exp1.fulfill()
      case .failure:
        print("Error")
      }
    }
    
    repository.contactFactory.getContacts { result in
      self.resData = result
      switch(result) {
      case .success(let contacts):
        exp2.fulfill()
        XCTAssertTrue(contacts.count == 1, "There is no one contact as expected: \(contacts.count)")
      case .failure(let error):
        XCTAssertNotNil(error, "Error")
      }
    }
    
    wait(for: [exp1,exp2], timeout: 0.501)
    
    
  }
  
  func testAddDuplicatedContact() {
     let contact = Contact(name: "Abigail", phoneNumber: "123123123")
    
      let exp1 = self.expectation(description: "Result complete. Contact Added.")
      let exp2 = self.expectation(description: "Result complete. Error Dupliccated contact")
      let exp3 = self.expectation(description: "Result complete. Just one contact")

    
      repository.contactFactory.add(contact: contact) { result in
        switch result {
        case .success:
          print("Repositorytests contact added")
          exp1.fulfill()
        case .failure(let error):
          print(">>>>>>> Error: \(error.localizedDescription)")
        }
      }
    
      repository.contactFactory.add(contact: contact) { result in
        switch result {
        case .success:
          print("Repositorytests contact added")
          exp2.fulfill()
        case .failure(let error):
          exp2.fulfill()
          print("Error \(error.localizedDescription)")
        }
      }
      
      repository.contactFactory.getContacts { result in
        self.resData = result
        switch(result) {
        case .success(let contacts):
           XCTAssertTrue(contacts.count == 1, "There is no one contact as expected. There are \(contacts.count)")
          exp3.fulfill()
        case .failure(let error):
          XCTAssertNotNil(error, "Error")
        }
      }
      
      wait(for: [exp1,exp2,exp3], timeout: 10)
    
  }
    
  func testDeleteContactFromRepository () {
    
    let contact = Contact(name: "Abigail", phoneNumber: "123123123")

    let exp1 = self.expectation(description: "Result complete. Contact Added.")
    let exp2 = self.expectation(description: "Result complete. Contact Deleted")
    let exp3 = self.expectation(description: "Result complete. It's empty")

    repository.contactFactory.add(contact: contact) { result in
      switch result {
      case .success:
        exp1.fulfill()
        print("Contact added" )
      case .failure(let error):
        print(">>>>>>> Error: \(error.localizedDescription)")
      }
    }
    
    repository.contactFactory.delete(contact: contact) { result in
      switch result {
      case .success:
        exp2.fulfill()
        print("Contact Deleted" )
      case .failure(let error):
        print(">>>>>>> Error: \(error.localizedDescription)")
      }
    }
    
    repository.contactFactory.getContacts { result in
      self.resData = result
      switch(result) {
      case .success(let contacts):
        exp3.fulfill()
        XCTAssertTrue(contacts.isEmpty,"Must be empty!. There are \(contacts.count)")
      case .failure(let error):
        XCTAssertNotNil(error, "Error")
      }
    }
    wait(for: [exp1,exp2,exp3], timeout: 6)

  }
  
  func testGetContactFromRepository() {
    let contact1 = Contact(name: "Abigail", phoneNumber: "123123123")
    let contact2 = Contact(name: "Pedro", phoneNumber: "123123123")


    let exp1 = self.expectation(description: "Result complete. Contact Added.")
    let exp2 = self.expectation(description: "Result complete. Contact Added")
    let exp3 = self.expectation(description: "Result complete. Two contacts")
    
    repository.contactFactory.add(contact: contact1) { result in
      switch result {
      case .success:
        exp1.fulfill()
        print("Contact added" )
      case .failure(let error):
        print(">>>>>>> Error: \(error.localizedDescription)")
      }
    }
    
    repository.contactFactory.add(contact: contact2) { result in
      switch result {
      case .success:
        exp2.fulfill()
        print("Contact added" )
      case .failure(let error):
        print(">>>>>>> Error: \(error.localizedDescription)")
      }
    }
    
    repository.contactFactory.getContacts { result in
      self.resData = result
      switch(result) {
      case .success(let contacts):
        exp3.fulfill()
        XCTAssertTrue(contacts.count == 2,"Must be 2. There are \(contacts.count)")
      case .failure(let error):
        XCTAssertNotNil(error, "Error")
      }
    }
    wait(for: [exp1,exp2,exp3], timeout: 6)
    
  }
  
  func testUpdateContact() {
    let contact = Contact(name: "Abigail", phoneNumber: "123123123")
    let newData = Contact(name: "Abigail", phoneNumber: "7887787873")
    let exp1 = self.expectation(description: "Result complete. Contact Added.")
    let exp2 = self.expectation(description: "Result complete. Contact Updated")
    let exp3 = self.expectation(description: "Result complete. Contact has data updated")
    
    repository.contactFactory.add(contact: contact) { result in
      switch result {
      case .success:
        exp1.fulfill()
        print("Contact added" )
      case .failure(let error):
        print(">>>>>>> Error: \(error.localizedDescription)")
      }
    }
    
    repository.contactFactory.update(contact: contact, dataToUpdate: newData ) { result in
      switch result {
      case .success:
        exp2.fulfill()
        print("Contact Updated" )
      case .failure(let error):
        print(">>>>>>> Error: \(error.localizedDescription)")
      }
    }
    
    repository.contactFactory.getContacts { result in
      self.resData = result
      switch(result) {
      case .success(let contacts):
        exp3.fulfill()
        XCTAssertTrue(newData == contacts[0],"Must be equal!. There are \(contacts.count)")
      case .failure(let error):
        XCTAssertNotNil(error, "Error")
      }
    }
    wait(for: [exp1,exp2,exp3], timeout: 6)
  }
    
}

// Contacts for testing
//      return [Contact(name: "Abigail", phoneNumber: "123123123"),
//              Contact(name: "Steve Jobs", phoneNumber: "123123123"),
//              Contact(name: "Bill Gates", phoneNumber: "+123123123"),
//              Contact(name: "Sundar Pichay", phoneNumber: "123123123"),
//              Contact(name: "Larry Page", phoneNumber: "+123123123"),
//              Contact(name: "Elon Musk", phoneNumber: "+43987654878"),
//              Contact(name: "Satia Nadella", phoneNumber: "+43789578943"),
//              Contact(name: "Joan Boluda", phoneNumber: "+43789578943"),
//              Contact(name: "Carl Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Kasy Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Lois Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Mark Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Crista Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Sofi Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Gerard Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Jaimi Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Tyrion Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Daniel Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Fakir Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Holi Jobs", phoneNumber: "+43987654878"),
//              Contact(name: "Nadia Jobs", phoneNumber: "+43987654878"),
