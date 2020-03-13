//
//  CoreDataStack.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 13/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

import CoreData

public class CoreDataStack {

  var container : NSPersistentContainer
  let context : NSManagedObjectContext
  let model : NSManagedObjectModel
  let psc: NSPersistentStoreCoordinator
 
  
  init(name : String) {
    container = hwContainer(name: name)
    self.context = container.viewContext
    self.model = container.managedObjectModel
    self.psc = container.persistentStoreCoordinator
  }
  
}


// MARK: - Functions
public func hwContainer(name: String) -> NSPersistentContainer {
  
  let container = NSPersistentContainer(name: name)
  
  container.loadPersistentStores(completionHandler: { (storeDescription, error) in
    print("Store URL: \(String(describing: storeDescription.url))")
    if let error = error as NSError? {
      fatalError("Unresolved error \(error), \(error.userInfo)")
    }
  })
  
  return container
}
