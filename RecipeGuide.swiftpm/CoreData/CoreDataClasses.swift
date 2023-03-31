//
//  CoreDataClasses.swift
//  
//
//  Created by Dylan Mace on 3/31/23.
//

import Foundation
import CoreData


@objc(CDIngredient)
class CDIngredient: NSManagedObject, Identifiable {
    @NSManaged var name: String

    static func generateNSEntity() -> NSEntityDescription {
        let ingredientEntity = NSEntityDescription()
        ingredientEntity.name = "CDIngredient"
        ingredientEntity.managedObjectClassName = "CDIngredient"

        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.type = .string
        ingredientEntity.properties.append(nameAttribute)
        return ingredientEntity
    }
}


protocol Shoppable: Codable {
    var id: String { get }
}



@objc(ShoppableItem)
class ShoppableItem: NSManagedObject, Identifiable {
    @NSManaged var id: String
    @NSManaged var data: Data?

    func update<T: Shoppable>(with item: T) {
        self.id = item.id
        guard let data = try? JSONEncoder().encode(item) else {
            return
        }
        self.data = data
    }

    func generateStruct<T: Shoppable>(withType: T.Type) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data else { return nil }
        let val = try? decoder.decode(T.self, from: data)
        return val
    }


    static func generateNSEntity() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = "ShoppableItem"
        entity.managedObjectClassName = "ShoppableItem"

        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "id"
        nameAttribute.type = .string

        let dataAttribute = NSAttributeDescription()
        dataAttribute.name = "data"
        dataAttribute.type = .binaryData
        dataAttribute.isOptional = true

        entity.properties.append(contentsOf: [nameAttribute, dataAttribute])
        return entity
    }
}
