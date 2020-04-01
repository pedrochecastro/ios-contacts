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
    
    
  }
  
  func testDeleteContactFromRepository () {
    
  }
  
  func testGetContactFromRepository() {
    
  }
  
  func testUpdateContact() {
    
  }
    

}
