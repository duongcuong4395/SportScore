//
//  FavoriteViewModel.swift
//  SportScore
//
//  Created by pc on 16/08/2024.
//

import Foundation

import CoreData

class FavoriteViewModel: ObservableObject {
    @Published var objs: [NSManagedObject] = []
    
    @Published var number: Int = 0
    
    func getObjsFavorite<Entity: NSManagedObject>(of obj: Entity.Type, sportype: SportType, from context: NSManagedObjectContext) {
        let condition = NSPredicate (format: "isFavorite = %d AND sportName like %@", true, sportype.rawValue)
        let modelExists = context.getEntities(ofType: obj, with: condition)
        print("getObjsFavorite.scheduleModels: ", modelExists.models.count)
        self.objs = modelExists.models
    }
    
    func getObjs(of sportype: SportType, from context: NSManagedObjectContext) -> [NSManagedObject] {
        var result: [NSManagedObject] = []
        let cates = sportype.getEntities()
        self.objs = []
        cates.forEach { cate in
            let condition = NSPredicate (format: "isFavorite = %d AND sportName like %@", true, sportype.rawValue)
            let modelExists = context.getEntities(ofType: cate, with: condition)
            result.append(contentsOf: modelExists.models)
            self.objs.append(contentsOf: modelExists.models)
        }
        return result
    }
    
    func getCount<Entity: NSManagedObject>(from objs: [Entity.Type], of sportype: SportType, from context: NSManagedObjectContext) {
        DispatchQueueManager.share.runOnMain {
            self.number = 0
            objs.forEach { obj in
                let condition = NSPredicate (format: "isFavorite = %d AND sportName like %@", true, sportype.rawValue)
                let modelExists = context.getEntities(ofType: obj, with: condition)
                self.number += modelExists.models.count
            }
        }
    }
    
    func removeAll() {
        self.objs = []
        self.number = 0
    }
}
