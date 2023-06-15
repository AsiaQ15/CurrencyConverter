//
//  ActualCostEntity+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 12.06.2023.
//
//

import Foundation
import CoreData


extension ActualCostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActualCostEntity> {
        return NSFetchRequest<ActualCostEntity>(entityName: "ActualCostEntity")
    }

    @NSManaged public var currency1: String?
    @NSManaged public var currency2: String?
    @NSManaged public var cost: Double
    
    internal class func createOrUpdate(data: CurrencyActual, with stack: CoreDataStack) {
        var current: ActualCostEntity?
        let currentFetch: NSFetchRequest<ActualCostEntity> = ActualCostEntity.fetchRequest()
        let subPredicate1 = NSPredicate(format: "(currency1 = %@)", data.currency1)
        let subPredicate2 = NSPredicate(format: "(currency2 = %@)", data.currency2)
        currentFetch.predicate = NSCompoundPredicate(type: .and, subpredicates: [subPredicate1, subPredicate2])
        do {
            let results = try stack.managedContext.fetch(currentFetch)
            if results.isEmpty {
                current = ActualCostEntity(context: stack.managedContext)
                current?.currency1 = data.currency1
                current?.currency2 = data.currency2
            } else {
                current = results.first
            }
            current?.update(data: data)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }

    internal func update(data: CurrencyActual) {
        self.currency1 = data.currency1
        self.currency2 = data.currency2
        self.cost = data.cost
    }

}

extension ActualCostEntity : Identifiable {

}

