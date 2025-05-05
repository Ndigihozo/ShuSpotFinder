//
//  LotUsage+CoreDataProperties.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/6/25.
//
//

import Foundation
import CoreData
import ShuSpotFinder

extension LotUsage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LotUsage> {
        return NSFetchRequest<LotUsage>(entityName: "LotUsage")
    }

    @NSManaged public var lotname: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var action: String?
    @NSManaged public var user: User?

}

extension LotUsage : Identifiable {

}
