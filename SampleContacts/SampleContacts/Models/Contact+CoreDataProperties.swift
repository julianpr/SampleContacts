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
    var lastNameInitial: String {
        get {
            let index = self.lastName?.index((self.lastName?.startIndex)!, offsetBy: 1)
            let initial = self.lastName?.substring(to: index!)
            let num = Int(initial!)
            if (num != nil)
            {
                return "#"
            }
            return initial!
        }
    }

}
