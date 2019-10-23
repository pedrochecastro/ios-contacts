//
//  Repository.swift
//  GoT
//
//  Created by Pedro Sánchez Castro on 16/7/17.
//  Copyright © 2017 Pedro Sánchez Castro. All rights reserved.
//

import Foundation

final class Repository{
    
    static let local = LocalFactory()
}

protocol ContactFactory {
    
    typealias FilterContact = (Contact)-> Bool
    
    var contacts : [Contact] {get}
    func contact(named: String) -> Contact?
    func contacts(filteredBy: FilterContact) -> [Contact]
    
  }

final class LocalFactory : ContactFactory {
    
    func contacts(filteredBy: FilterContact) -> [Contact] {
        let filtered = Repository.local.contacts.filter(filteredBy)
        return filtered
    }

    var contacts: [Contact] {
        get {
            return [Contact(name: "Steve Jobs", phoneNumber: "+43987654878"),
                    Contact(name: "Bill Gates", phoneNumber: "+43987654878"),
                    Contact(name: "Sundar Pichay", phoneNumber: "+43987654878"),
                    Contact(name: "Larry Page", phoneNumber: "+43987654878"),
                    Contact(name: "Elon Musk", phoneNumber: "+43987654878"),
                    Contact(name: "Satia Nadella", phoneNumber: "+43789578943")
                ].sorted()
        }
    }
    
}

extension ContactFactory {
    
    func contact(named : String) -> Contact? {
         return contacts.filter({$0.name == named}).first
    }
    
}
