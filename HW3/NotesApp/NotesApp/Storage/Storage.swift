//
//  NotesStorage.swift
//  NotesApp
//
//  Created by Viacheslav Bernadzikovskyi on 10.12.2020.
//

import Foundation
import CoreData

final class NotesStorage {
    enum Issue: Error {
        case noValue
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Persistence")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveNote(person: Note) throws {
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: persistentContainer.viewContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)
        managedObject.setValue(person.name, forKey: "name")
        managedObject.setValue(person.age, forKey: "age")
        saveContext()
    }
    
    func fetchNotes() throws -> Note {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        let results = try persistentContainer.viewContext.fetch(fetchRequest)
        guard let managedObject = results.first else { throw Issue.noValue }
        let name = managedObject.value(forKeyPath: "name") as? String
        let age = managedObject.value(forKeyPath: "age") as? Int
        return PersonModel(name: name, age: age)
    }
}
