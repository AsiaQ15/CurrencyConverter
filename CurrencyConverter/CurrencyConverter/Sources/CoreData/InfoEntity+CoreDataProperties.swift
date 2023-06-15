//
//  InfoEntity+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Ася Купинская on 12.06.2023.
//
//

import Foundation
import CoreData


extension InfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InfoEntity> {
        return NSFetchRequest<InfoEntity>(entityName: "InfoEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var isMain: String?
    
    internal class func createOrUpdate(data: CurrencyInfo, with stack: CoreDataStack) {
        let currencyID = Int32(data.id)
        var currentInfo: InfoEntity?
        let currencyPostFetch: NSFetchRequest<InfoEntity> = InfoEntity.fetchRequest()
        let itemIDPredicate = NSPredicate(format: "(id = %i)", currencyID)
        currencyPostFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [itemIDPredicate])
        do {
            let results = try stack.managedContext.fetch(currencyPostFetch)
            if results.isEmpty {
                currentInfo = InfoEntity(context: stack.managedContext)
                currentInfo?.id = Int32(currencyID)
            } else {
                currentInfo = results.first
            }
            currentInfo?.update(data: data)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    internal func update(data: CurrencyInfo) {
        self.id = data.id
        self.name = data.name
        self.isMain = String(data.isMain)
    }

}

extension InfoEntity : Identifiable {

}
