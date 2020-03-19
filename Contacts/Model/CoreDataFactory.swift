//
//  CoreDataFactory.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 24/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//
import UIKit
import CoreData

final class CoreDataFactory: ContactFactory {
  
  let cds = CoreDataStack(name: "ContactCD")
  
  var contacts: [Contact] {
    get {
      return fetchAllContacts()
    }
    set {}
  }
  
  func add(contact: Contact) {
    let contactCD = ContactCD(context: cds.context)
    contactCD.name = contact.name
    contactCD.phoneNumber = contact.phoneNumber
    contactCD.contactImage = contact.contactImage?.pngData() as NSData?
    
    do {
      // Number of Objects pending
      let newObjectsCount = cds.context.insertedObjects.count
      print("Preparing to save \(newObjectsCount)")
      // Save
      try cds.context.save()
      print("Saved")
    } catch {
      fatalError("Unresolved error")
    }
    
    
  }
  
  func delete(contact: Contact) {
    
    
    
    // Delete Contact
    let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == '\(contact.name)'")
    print ("fetched: " + fetchRequest.description)
    
    do {
      let result = try cds.context.fetch(fetchRequest)
      print("Num records to delete: \( result.count )")
      result.forEach {
        print("Project: + \(String(describing: $0.name))")
      }
      cds.context.delete(result.first!) // to delete an object, just call delete on the context
    } catch {
      print("Here's the info I have \(error.localizedDescription)")
    }
    
    //Update
    self.contacts = fetchAllContacts()
    print(self.contacts.count)
  }
  
  func update(contact: Contact, newContact: Contact) {
    
  }
  
  func contains(contact: Contact) -> Bool {
    return false
  }
  
}

extension CoreDataFactory {
  func fetchAllContacts() -> [Contact] {
    
    var contacts: [Contact] = []
    
    // Fetch all contacts
    let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest()
    
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20
    
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    print ("Fetched: " + fetchRequest.description)
    
    do {
      let result = try cds.context.fetch(fetchRequest)
      print("Num records to fetch: \( result.count )")
      result.forEach {
        let contact = Contact()
        contact.name = $0.name ?? "Unname"
        contact.phoneNumber = $0.phoneNumber ?? "NoPhone"
        contact.contactImage = UIImage(data: $0.contactImage! as Data)
        
        contacts.append(contact)
        
      }
      
    } catch {
      print("Error fetching  projects")
      print("Here's the info I have \(error.localizedDescription)")
    }
    
    return contacts
  }
  
}


