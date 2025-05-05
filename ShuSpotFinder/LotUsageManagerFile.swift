//
//  File.swift
//  ShuSpotFinder
//
//  Created by d.igihozo on 5/6/25.
//

import Foundation
import CoreData

class LotUsageManager {
    // Static method to save lot usage
    static func saveLotUsage(lotName: String, action: String, context: NSManagedObjectContext) {
        // Create a new LotUsage instance
        let usage = LotUsage(context: context)
        usage.lotname = lotName
        usage.action = action
        usage.timestamp = Date()

        do {
            try context.save()
            print("Lot usage saved for \(lotName)!")
        } catch {
            print("Error saving lot usage: \(error.localizedDescription)")
        }
    }
}

