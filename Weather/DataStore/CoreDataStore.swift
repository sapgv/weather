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
        return components.count > 1 ? components[1] : components[0]
    }
    
}


extension NSManagedObjectContext {
    
    func insert<T: NSManagedObject>(entity: T.Type) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: entity.entityName, into: self) as! T
    }
    
}


class CoreDataStore {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    
    enum SaveResult {
        case success
        case rollback
        case noChanges
    }
    
    static func save(in context: NSManagedObjectContext? = nil, completion: ((SaveResult) -> Void)? = nil) {
        
        let context = context != nil ? context! : self.context
        if context.hasChanges {
            
            do {
                try context.save()
                completion?(.success)
            }
            catch {
                context.rollback()
                completion?(.rollback)
            }
        }
        else {
            completion?(.noChanges)
        }

    }
    
    //MARK: - Create

    static func new<T: NSManagedObject>(entity: T.Type, context: NSManagedObjectContext? = nil) -> T {
        let context = context ?? self.context
        return NSEntityDescription.insertNewObject(forEntityName: entity.entityName, into: context) as! T
    }
    
    //MARK: - Find
    
    static func find<T: NSManagedObject>(
        entity: T.Type,
        predicates: [NSPredicate]? = nil,
        sort: [NSSortDescriptor]? = nil,
        count: Int? = nil,
        in context: NSManagedObjectContext? = nil) -> [T] {
        let context = context ?? self.context
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: entity.entityName)
            fetchRequest.sortDescriptors = sort
            
            if let predicates = predicates {
                fetchRequest.predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
            }
            
            if let count = count {
                fetchRequest.fetchLimit = count
            }
            fetchRequest.returnsObjectsAsFaults = false
            
            let results = try context.fetch(fetchRequest)
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
        predicates: [NSPredicate]? = nil,
        sort: [NSSortDescriptor]? = nil,
        in context: NSManagedObjectContext? = nil
        ) -> T? {
        
        let results = find(entity: entity, predicates: predicates, sort: sort, count: 1, in: context)
        return results.count > 0 ? results[0] : nil
    }
    
    static func findOne<T: NSManagedObject>(
        entity: T.Type,
        predicate: NSPredicate? = nil,
        sort: [NSSortDescriptor]? = nil,
        in context: NSManagedObjectContext? = nil
        ) -> T? {
        
        let predicates: [NSPredicate] = predicate != nil ? [predicate!] : []
        let results = find(entity: entity, predicates: predicates, sort: sort, count: 1, in: context)
        return results.count > 0 ? results[0] : nil
    }
    
    //MARK: - Remove
    
    static func delete<T: NSManagedObject>(_ data: T, from context: NSManagedObjectContext? = nil, completion: ((SaveResult) -> Void)? = nil) {
    
        let context = context != nil ? context! : self.context
        context.delete(data)
        save(in: context) { saveResult in
            completion?(saveResult)
        }
        
    }
    
}
