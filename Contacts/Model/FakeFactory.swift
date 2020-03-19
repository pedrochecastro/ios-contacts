//
//  FakeFactory.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 24/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//

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
