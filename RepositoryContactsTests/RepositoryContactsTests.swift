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
        XCTAssertTrue(contacts.isEmpty, "Is not empty")
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
        print("Repositorytests contact added")
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
        XCTAssertTrue(contacts.count == 1, "There is no one contact as expected")
      case .failure(let error):
        XCTAssertNotNil(error, "Error")
      }
    }
    
    wait(for: [exp1,exp2], timeout: 2)
    
    
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
        case .failure(let error):
          exp2.fulfill()
          print("Error \(error.localizedDescription)")
        }
      }
      
      repository.contactFactory.getContacts { result in
        self.resData = result
        switch(result) {
        case .success(let contacts):
          exp3.fulfill()
          XCTAssertTrue(contacts.count == 1, "There is no one contact as expected. There are \(contacts.count)")
        case .failure(let error):
          XCTAssertNotNil(error, "Error")
        }
      }
      
      wait(for: [exp1,exp2,exp3], timeout: 6)
    
  }
    
  func testDeleteContactFromRepository () {
    
  }
  
  func testGetContactFromRepository() {
    
  }
  
  func testUpdateContact() {
    
  }
  
  func testContactPropertyToGetContacts(){
    
  }
    

}
