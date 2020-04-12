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
    
    //Delete all entities if exists
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactCD")
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
     try context.executeAndMergeChanges(using: batchDeleteRequest)
    } catch {
      print("##### Error deleting:\(error.localizedDescription)")
    }
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

extension NSManagedObjectContext {
    
    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes to bring the given managed object context up to date.
    ///
    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
    /// - Throws: An error if anything went wrong executing the batch deletion.
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
