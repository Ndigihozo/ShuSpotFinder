//
//  Users+CoreDataProperties.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/2/25.
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
    @NSManaged public var passwordConfirmation: String?

}

extension User : Identifiable {

}
