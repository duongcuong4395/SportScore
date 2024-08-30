//
//  CoreDataManage.swift
//  SportScore
//
//  Created by pc on 14/08/2024.
//

import Foundation
import CoreData

protocol ModelCoreData: Codable {
    associatedtype objCoreData
    
    func convertToCoreData(for context: NSManagedObjectContext) throws -> objCoreData
    
    func checkExists(in context: NSManagedObjectContext
                     , complete: @escaping (Bool, [Any]) -> Void) throws
}

extension ModelCoreData {
    func save(into context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("save model into core data error: ", error.localizedDescription)
        }
    }
    
    func removeAllCoreData(by entityName: String
                           , into context: NSManagedObjectContext
                           , completion: @escaping (Result<Bool, Error>) -> Void
    ) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try! context.fetch(fetchRequest)
            for obj in result {
                guard let objData = obj as? NSManagedObject else { continue }
                
                removeItem(by: objData, into: context)
            }
            completion(.success(true))
        } catch {
            print("Remove All core data for: ", entityName)
            completion(.failure(error))
        }
    }
    
    func removeItem(by obj: NSManagedObject
                    , into context: NSManagedObjectContext) {
        context.delete(obj)
        save(into: context)
    }
    
    func removeItem(into context: NSManagedObjectContext, complete: @escaping ( Result<Bool, Error>) -> Void) {
        
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        
        backgroundContext.perform {
            do {
                try self.checkExists(in: backgroundContext) {
                    check, objs in
                    if check {
                        if objs.count <= 0 {
                            complete(.success(true))
                            return
                        }
                        removeItem(by: objs[0] as! NSManagedObject, into: backgroundContext)
                        
                        self.save(into: backgroundContext)
                        self.save(into: context)
                        
                        complete(.success(true))
                    } else {
                        complete(.success(true))
                    }
                }
            } catch {
                
            }
        }
        
        
    }
    
    func add(into context: NSManagedObjectContext
             , completion: @escaping (Result<Bool, Error>) -> Void) {
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        backgroundContext.parent = context
        
        backgroundContext.perform {
            do {
                try self.checkExists(in: backgroundContext, complete: { sucess, objs in
                    if sucess {
                        completion(.success(true))
                    } else {
                        _ = try? convertToCoreData(for: backgroundContext)
                        self.save(into: backgroundContext)
                        self.save(into: context)
                        completion(.success(true))
                    }
                })
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func toggleAddAndRemove(for context: NSManagedObjectContext, complete: @escaping (Bool, Bool) -> Void) {
        
        
        try? checkExists(in: context, complete: { success, objs in
            if success {
                removeItem(into: context) { result in
                    switch result {
                    case .success(let res):
                        complete(success, res)
                    case .failure(let err):
                        complete(success, false)
                    }
                }
            } else {
                add(into: context) { result in
                    switch result {
                    case .success(let res):
                        complete(success, res)
                    case .failure(let err):
                        complete(success, false)
                    }
                }
            }
        })
        
    }
    
}


protocol SportCoreDataVM {
    associatedtype model: ModelCoreData
    
    func checkExists<T: ModelCoreData>(from model: T, viewContext: NSManagedObjectContext, complete: @escaping (Bool) -> Void) throws
    
    
}

extension SportCoreDataVM {
    func checkExists<T: ModelCoreData>(from model: T, viewContext: NSManagedObjectContext, complete: @escaping (Bool) -> Void) throws {
        
        try? model.checkExists(in: viewContext, complete: { check, objs in
            complete(check)
        })
    }
}

extension NSManagedObjectContext {
    
    func doesEntityExist<Entity: NSManagedObject>(ofType entityType: Entity.Type, with predicate: NSPredicate?) -> (result: Bool, models: [Entity]) {
        

        do {
            let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: entityType))
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = 1 // Chỉ cần một kết quả để kiểm tra
            
            let results = try self.fetch(fetchRequest)
            //print("fetching.success: ", results)
            return (!results.isEmpty, results)
        } catch {
            print("Error fetching: \(error)")
            return (false, [])
        }
    }
    
    func getEntities<Entity: NSManagedObject>(ofType entityType: Entity.Type, with condition: NSPredicate?) -> (result: Bool, models: [Entity]) {
        let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: entityType))
        fetchRequest.predicate = condition

        do {
            let results = try self.fetch(fetchRequest)
            return (!results.isEmpty, results)
        } catch {
            print("Error fetching: \(error)")
            return (false, [])
        }
    }
}
