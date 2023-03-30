//
//  CoreDataContainer.swift
//  RecipeGuide
//
//  Created by Dylan Mace on 3/29/23.
//

import Foundation
import SwiftUI
import CoreData

@objc(CDIngredient)
class CDIngredient: NSManagedObject, Identifiable {
    @NSManaged var name: String
}

class Persistence {
    static let shared = Persistence()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let pantryEntity = NSEntityDescription()
        pantryEntity.name = "CDIngredient"
        pantryEntity.managedObjectClassName = "CDIngredient"

        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.type = .string
        pantryEntity.properties.append(nameAttribute)

        let model = NSManagedObjectModel()
        model.entities = [pantryEntity]

        let container = NSPersistentContainer(name: "PantryModel", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("failed with: \(error.localizedDescription)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        container.viewContext.automaticallyMergesChangesFromParent = true
        self.container = container
    }
}
