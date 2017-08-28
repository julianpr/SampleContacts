//
//  Contact+CoreDataProperties.swift
//  
//
//  Created by Julian Pratama on 2017-08-28.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var email: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phone: String?
    @NSManaged public var profilePic: String?
    @NSManaged public var id: Int32

}
