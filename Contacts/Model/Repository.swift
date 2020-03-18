//
//  Repository.swift
//
//  Created by Pedro Sánchez Castro on 16/7/17.
//  Copyright © 2017 Pedro Sánchez Castro. All rights reserved.
//

import UIKit
import CoreData

enum RepositorySource {
  case fake
  case coredata
}

final class Repository {
  
  static let shared =  Repository(source: RepositorySource.coredata)
  var contactsSource: ContactFactory
  
  
  init(source: RepositorySource) {
    switch source {
    case .fake:
      self.contactsSource = FakeFactory()
    case .coredata:
      self.contactsSource = CoreDataFactory()
    }
  }

}

protocol ContactFactory {
  
  var contacts : [Contact] {get set}
  func add(contact: Contact)
  func delete(contact: Contact)
  func update(contact: Contact, newContact: Contact)
  func contains(contact: Contact) -> Bool
  
}

final class FakeFactory : ContactFactory {

    var contacts: [Contact] {
        get {
            return [Contact(name: "Abigail", phoneNumber: "123123123"),
                    Contact(name: "Steve Jobs", phoneNumber: "123123123"),
                    Contact(name: "Bill Gates", phoneNumber: "+123123123"),
                    Contact(name: "Sundar Pichay", phoneNumber: "123123123"),
                    Contact(name: "Larry Page", phoneNumber: "+123123123"),
                    Contact(name: "Elon Musk", phoneNumber: "+43987654878"),
                    Contact(name: "Satia Nadella", phoneNumber: "+43789578943"),
                    Contact(name: "Joan Boluda", phoneNumber: "+43789578943"),
                    Contact(name: "Carl Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Kasy Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Lois Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Mark Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Crista Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Sofi Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Gerard Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Jaimi Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Tyrion Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Daniel Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Fakir Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Holi Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Nadia Jobs", phoneNumber: "+43987654878"),

                ].sorted()
        }
      set { }
    }
 
  // MARK: - Public Methods
  
    func add(contact: Contact) {
      contacts.append(contact)
    }
  
    func delete(contact: Contact) {
      guard let i = contacts.firstIndex(of: contact) else {return}
      contacts.remove(at: i)
    }
  
    func update(contact: Contact, newContact: Contact) {
       delete(contact: contact)
       add(contact: newContact)
    }
  
    public func contains(contact: Contact) -> Bool{
      return contacts.contains(contact)
    }

}

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

