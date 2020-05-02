//
//  Repository.swift
//
//  Created by Pedro Sánchez Castro on 16/7/17.
//  Copyright © 2017 Pedro Sánchez Castro. All rights reserved.
//


class Repository {
  
  let contactFactory: ContactFactory
  
  init(contactFactory: ContactFactory) {
    self.contactFactory = contactFactory
  }
}
