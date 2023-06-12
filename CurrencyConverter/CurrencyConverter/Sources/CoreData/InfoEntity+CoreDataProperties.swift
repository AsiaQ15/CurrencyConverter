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

    @NSManaged public var nameShort: String?
    @NSManaged public var nameFull: String?
    @NSManaged public var photo: String?
    
    internal class func createOrUpdate(data: CurrencyInfo, with stack: CoreDataStack) {
        //let pictureID = Int32(item.id)
        var current: InfoEntity?
        let currentFetch: NSFetchRequest<InfoEntity> = InfoEntity.fetchRequest()

//        let newItemIDPredicate = NSPredicate(format: "%@ = %i", (\PictureEntity.id)._kvcKeyPathString!, pictureID)
//        currentPostFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newItemIDPredicate])
//
//        //let request = NSFetchRequest(entityName: "Location")
        let subPredicate1 = NSPredicate(format: "(nameShort = %@)", data.nameShort)
        
        currentFetch.predicate = NSCompoundPredicate(type: .and, subpredicates: [subPredicate1])

        
        do {
            let results = try stack.managedContext.fetch(currentFetch)
            if results.isEmpty {
                current = InfoEntity(context: stack.managedContext)
                current?.nameShort = data.nameShort
            } else {
                current = results.first
            }
            current?.update(data: data)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        //print(current)
    }

    internal func update(data: CurrencyInfo) {
        self.nameShort = data.nameShort
        self.nameFull = data.nameFull
        self.photo = data.photo
    }

}

extension InfoEntity : Identifiable {

}
