//
//  CoreDataContainer.swift
//  RecipeGuide
//
//  Created by Dylan Mace on 3/29/23.
//

import Foundation
import SwiftUI
import CoreData

class Persistence {
    static let shared = Persistence()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = NSManagedObjectModel()
        model.entities = [CDIngredient.generateNSEntity(), ShoppableItem.generateNSEntity()]

        let container = NSPersistentContainer(name: "RecipeGenie", managedObjectModel: model)

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
