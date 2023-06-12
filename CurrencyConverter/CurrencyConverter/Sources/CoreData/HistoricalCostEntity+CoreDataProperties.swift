//
//  HistoricalCostEntity+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 12.06.2023.
//
//

import Foundation
import CoreData


extension HistoricalCostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoricalCostEntity> {
        return NSFetchRequest<HistoricalCostEntity>(entityName: "HistoricalCostEntity")
    }

    @NSManaged public var currency1: String?
    @NSManaged public var currency2: String?
    @NSManaged public var date: String?
    @NSManaged public var cost: Double
    @NSManaged public var id: Int32
    
    internal class func createOrUpdate(data: CurrencyHistorical, with stack: CoreDataStack) {
        //let pictureID = Int32(item.id)
        var current: HistoricalCostEntity?
        let currentFetch: NSFetchRequest<HistoricalCostEntity> = HistoricalCostEntity.fetchRequest()

//        let newItemIDPredicate = NSPredicate(format: "%@ = %i", (\PictureEntity.id)._kvcKeyPathString!, pictureID)
//        currentPostFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newItemIDPredicate])
//
//        //let request = NSFetchRequest(entityName: "Location")
        let subPredicate1 = NSPredicate(format: "(id = %i)", data.id)
        let subPredicate2 = NSPredicate(format: "(currency1 = %@)", data.currency1)
        let subPredicate3 = NSPredicate(format: "(currency2 = %@)", data.currency2)
        
        currentFetch.predicate = NSCompoundPredicate(type: .and, subpredicates: [subPredicate1, subPredicate2, subPredicate3])

        do {
            let results = try stack.managedContext.fetch(currentFetch)
            if results.isEmpty {
                current = HistoricalCostEntity(context: stack.managedContext)
                current?.id = data.id
                current?.currency1 = data.currency1
                current?.currency2 = data.currency2
            } else {
                current = results.first
            }
            current?.update(data: data)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        //print(current)
    }

    internal func update(data: CurrencyHistorical) {
        self.id = data.id
        self.currency1 = data.currency1
        self.currency2 = data.currency2
        self.cost = data.cost
        self.date = data.date
    }

}

extension HistoricalCostEntity : Identifiable {

}
