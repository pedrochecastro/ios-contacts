//
//  ContactCD+CoreDataProperties.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 11/03/2020.
//  Copyright © 2020 checastro.com. All rights reserved.
//
//

import Foundation
import CoreData


extension ContactCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactCD> {
        return NSFetchRequest<ContactCD>(entityName: "ContactCD")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var contactImage: NSData?

}
