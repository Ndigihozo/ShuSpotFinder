//
//  User+CoreDataProperties.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/4/25.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var passwordpasswordConfirmation: String?

}

extension User : Identifiable {

}
