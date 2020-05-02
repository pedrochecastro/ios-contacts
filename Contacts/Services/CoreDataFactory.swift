////
////  CoreDataFactory.swift
////  Contacts
////
////  Created by Pedro Sánchez Castro on 24/03/2020.
////  Copyright © 2020 checastro.com. All rights reserved.
////
//import UIKit
//import CoreData
//
//final class CoreDataFactory: ContactFactory {
//
//  // MARK: - Var
//   let cds = CoreDataStack(name: "ContactCD")
//  
//  
//  func getContacts(completionHandler: (Result<[Contact], Error>) -> Void) {
//    
//    var contacts: [Contact] = []
//
//    // Fetch all contacts
//    let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest()
//
//    // Set the batch size to a suitable number.
//    fetchRequest.fetchBatchSize = 20
//
//    let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
//    fetchRequest.sortDescriptors = [sortDescriptor]
//    print ("Fetched: " + fetchRequest.description)
//
//    do {
//      let result = try cds.context.fetch(fetchRequest)
//      print("Num records to fetch: \( result.count )")
//      result.forEach {
//        let contact = Contact()
//        contact.name = $0.name ?? "Unname"
//        contact.phoneNumber = $0.phoneNumber ?? "NoPhone"
//        //TODO
////        contact.contactImage = UIImage(data: $0.contactImage! as Data)
//
//        contacts.append(contact)
//      }
//      completionHandler(.success(contacts))
//
//    } catch (let error) {
//      print("Error fetching  contacts")
//      print("Here's the info I have \(error.localizedDescription)")
//      completionHandler(.failure(error))
//    }
//  }
//  
//  func add(contact: Contact, completionHandler: (Result<Bool, Error>) -> Void) {
//    // Query to find is contact duplicated
//   let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest()
//   fetchRequest.predicate = NSPredicate(format: "name == '\(contact.name)'")
//   print ("fetched: " + fetchRequest.description)
//    do {
//        let result = try cds.context.fetch(fetchRequest)
//        print("🚩 If founded duplicated: \( result.count )")
//        if (result.count == 0) {
//          let contactCD = ContactCD(context: cds.context)
//          contactCD.name = contact.name
//          contactCD.phoneNumber = contact.phoneNumber
//          contactCD.contactImage = contact.contactImage?.pngData() as NSData?
//          
//          let newObjectsCount = cds.context.insertedObjects.count
//          print("Preparing to save \(newObjectsCount)")
//          try cds.context.save()
//          completionHandler(.success(true))
//        } else {
//          throw ContactFactoryError.duplicated(message: "User is duplicated")
//      }
//    } catch {
//             print(error.localizedDescription)
//             completionHandler(.failure(error))
//    }
//
//  }
//  
//  func delete(contact: Contact, completionHandler: (Result<Bool, Error>) -> Void) {
//      // Query
//      let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest()
//      fetchRequest.predicate = NSPredicate(format: "name == '\(contact.name)'")
//      print ("fetched: " + fetchRequest.description)
//
//      do {
//        let result = try cds.context.fetch(fetchRequest)
//        print("Num records to delete: \( result.count )")
//        result.forEach {
//          print("Contact: + \(String(describing: $0.name))")
//        }
//        cds.context.delete(result.first!) // to delete an object, just call delete on the context
//        completionHandler(.success(true))
//      } catch {
//        print("Here's the info I have \(error.localizedDescription)")
//        completionHandler(.failure(error))
//      }
//
//  }
//  
//  func update(contact: Contact, dataToUpdate: Contact, completionHandler: (Result<Bool, Error>) -> Void) {
//    // Query
//         let fetchRequest: NSFetchRequest<ContactCD> = ContactCD.fetchRequest()
//         fetchRequest.predicate = NSPredicate(format: "name == '\(contact.name)'")
//         print ("fetched: " + fetchRequest.description)
//
//         do {
//           let result = try cds.context.fetch(fetchRequest)
//           let contactToUpdate = result[0]
//           contactToUpdate.name = dataToUpdate.name
//           contactToUpdate.phoneNumber = dataToUpdate.phoneNumber
//          // Update picture
//          
//          try cds.context.save()// Save
//           completionHandler(.success(true))
//         } catch {
//           print("Here's the info I have \(error.localizedDescription)")
//          completionHandler(.failure(error))
//         }
//  }
//  
//  func contains(contact: Contact) -> Bool {
//    return false
//  }
//  
//}
