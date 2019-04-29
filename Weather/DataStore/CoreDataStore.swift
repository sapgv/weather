//
//  CoreDataStore.swift
//  Weather
//
//  Created by Sapgv on 24/03/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension NSManagedObject {

    class var entityName: String {
        let components = NSStringFromClass(self).components(separatedBy: ".")
        return components[1]
    }
    
//    class func new(in context: NSManagedObjectContext? = nil) -> NSManagedObject {
//        let context = context ?? CoreDataStore.context
//        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
////        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
////        return unsafeDowncast(object, to: self)
//    }
    
}


extension NSManagedObjectContext {
    
    func insert<T: NSManagedObject>(entity: T.Type) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: entity.entityName, into: self) as! T
    }
    
}

class CoreDataStore {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    
    static func save(in context: NSManagedObjectContext? = nil) {
        
        let context = context != nil ? context! : self.context
        if context.hasChanges {
            
            do {
                try context.save()
            }
            catch {
                context.rollback()
            }
        }
        else {
            //
        }

    }
    
    //MARK: - Create

    static func new<T: NSManagedObject>(entity: T.Type, context: NSManagedObjectContext? = nil) -> T {
        let context = context ?? self.context
        return NSEntityDescription.insertNewObject(forEntityName: entity.entityName, into: context) as! T
    }
//    static func new<T: NSManagedObject>(entity: String, context: NSManagedObjectContext? = nil) -> T {
//        return NSEntityDescription.insertNewObject(forEntityName: entity, into: context != nil ? context! : self.context) as! T
//    }
    
    //MARK: - Find
    
    static func find<T: NSManagedObject>(
        entity: T.Type,
        predicate: NSPredicate? = nil,
        sort: [NSSortDescriptor]? = nil,
        count: Int? = nil,
        in context: NSManagedObjectContext? = nil) -> [T] {
        
        do {
            
            let fetchRequest = NSFetchRequest<T>(entityName: entity.entityName)
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sort
            
            if count != nil {
                fetchRequest.fetchLimit = count!
            }
            let results = try context!.fetch(fetchRequest)
            
            if results.count == 0 {
                return []
            }
            else {
                return results
            }
        }
        catch {
            return []
        }
    }
    
    static func findOne<T: NSManagedObject>(
        entity: T.Type,
        predicate: NSPredicate? = nil,
        sort: [NSSortDescriptor]? = nil,
        in context: NSManagedObjectContext? = nil) -> T? {
        
        let results = find(entity: entity, predicate: predicate, sort: sort, count: 1, in: context)
        return results.count > 0 ? results[0] : nil
    }
    
    static func findOne<T: NSManagedObject>(
        entity: T.Type,
        predicates: [NSPredicate],
        sort: [NSSortDescriptor]? = nil,
        in context: NSManagedObjectContext? = nil) -> T? {
        return findOne(entity: entity, predicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicates), sort: sort, in: context)
    }
    
    //MARK: - Remove
    
    static func delete<T: NSManagedObject>(_ data: T, from context: NSManagedObjectContext? = nil) {
    
        let context = context != nil ? context! : self.context
        context.delete(data)
        save(in: context)
        
    }
    
}
