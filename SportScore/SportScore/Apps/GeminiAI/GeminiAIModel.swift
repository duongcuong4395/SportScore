//
//  GeminiAIModel.swift
//  SportScore
//
//  Created by pc on 11/09/2024.
//

import Foundation


import GoogleGenerativeAI
import CoreData

// MARK: - For model
struct GeminiAIModel: Codable {
    var itemKey: String
    var valueItem: String
    
    enum CodingKeys: String, CodingKey {
        case itemKey = "itemKey"
        case valueItem = "valueItem"
    }
    
    init() {
        self.itemKey = ""
        self.valueItem = ""
    }
    
    init(itemKey: String, valueItem: String) {
        self.itemKey = itemKey
        self.valueItem = valueItem
    }
}


extension GeminiAIModel: ModelCoreData {
    
    
    typealias objCoreData = GeminiAI
    
    var entityName: String {
        "GeminiAI"
    }
    
    func checkExists(in context: NSManagedObjectContext, complete: @escaping (Bool, [Any]) -> Void) throws {
        let condition = NSPredicate(format: "itemKey like %@", itemKey)
        let objs = context.doesEntityExist(ofType: objCoreData.self, with: condition)
        complete(objs.result, objs.models)
    }
    
    func convertToCoreData(for context: NSManagedObjectContext) throws -> GeminiAI {
        let geminiAICD = GeminiAI(context: context)
        geminiAICD.itemKey = self.itemKey
        geminiAICD.valueItem = self.valueItem
        return geminiAICD
    }
}


// MARK: - Gemini Status
enum GeminiStatus {
    case NotExistsKey
    case ExistsKey
    case SendReqestFail
    case Success
}

