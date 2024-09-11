//
//  GeminiAI+CoreDataProperties.swift
//  SportScore
//
//  Created by pc on 11/09/2024.
//
//

import Foundation
import CoreData


extension GeminiAI {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeminiAI> {
        return NSFetchRequest<GeminiAI>(entityName: "GeminiAI")
    }

    @NSManaged public var itemKey: String?
    @NSManaged public var valueItem: String?

}

extension GeminiAI : Identifiable {

}
