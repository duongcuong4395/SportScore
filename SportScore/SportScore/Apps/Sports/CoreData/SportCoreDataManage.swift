//
//  SportCoreDataManage.swift
//  SportScore
//
//  Created by pc on 14/08/2024.
//

import Foundation
import CoreData


class SportCoreDataManage: ObservableObject {
    var container = NSPersistentContainer(name: "SportCoreData")
    
    init() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.container.loadPersistentStores { description, error in
                if let error = error as NSError? {
                    fatalError("Error loading container \(error). \(error.userInfo)")
                }
            } as Any
        }
    }
}
