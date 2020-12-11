//
//  NoteDataManager.swift
//  NotesApp
//
//  Created by Viacheslav Bernadzikovskyi on 08.11.2020.
//

import Foundation
import CoreData

class NoteDataManager {
    private(set) var notes: [Note] = []
    private(set) var deletedNotes = [Note]()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotesDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init() {
        prepareForUse()
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Saved")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        print("Saved context")
    }
    
    var searchQuery: String?
    
    func getNotes() -> [Note] {
        if(searchQuery == nil) {
            return notes
        } else {
            return searchBy(name: searchQuery!)
        }
    }
    
    func getDeletedNotes() -> [Note] {
        if(searchQuery == nil) {
            return deletedNotes
        } else {
            return searchDeletedBy(name: searchQuery!)
        }
    }
    
    func createNote(named name:String, text: String = "", tags: Set<String> = []) {
        if(isNoteNameUnique(name)){
            let note = Note(named: name, text: text, tags: tags)
            notes.append(note)
            let entity = NSEntityDescription.entity(forEntityName: "NoteEntity", in: persistentContainer.viewContext)!
            let managedObject = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)
            managedObject.setValue(note.id, forKey: "id")
            managedObject.setValue(name, forKey: "name")
            managedObject.setValue(text, forKey: "text")
            managedObject.setValue(false, forKey: "isFavourite")
            managedObject.setValue(Date(), forKey: "creationDate")


            saveContext()
            do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            print(results)
            } catch {

            }
            
        } else {
            // TODO: throw error or maybe reimplement to return true/false
        }
    }
    
    func getNote(with id:Int) -> Note? {
        return notes.first(where: { $0.id == id })
    }
    
    func updateNote(with id: Int, name: String, text: String, tags: Set<String>) {
        if let index = notes.firstIndex(where: {$0.id == id}) {
            notes[index].name = name
            notes[index].text = text
            notes[index].tags = tags
        }
        
        updateCoreNote(id: id, named: name, text: text, isFavourite: false, creationDate: Date(), deletionDate: nil)
    }
    
    func deleteNote(with id: Int) {
        if let index = notes.firstIndex(where: {$0.id == id}) {
            var note = notes[index]
            note.deletionDate = Date()
            deletedNotes.append(note)
            notes.remove(at: index)
            updateCoreNote(id: id, named: note.name, text: note.text, isFavourite: false, creationDate: Date(), deletionDate: note.deletionDate, updateDeletion: true)
            
        }
    }
    
    func restoreNote(with id: Int) {
        if let index = deletedNotes.firstIndex(where: {$0.id == id}) {
            var note = deletedNotes[index]
            note.deletionDate = nil
            notes.append(note)
            deletedNotes.remove(at: index)
            
            updateCoreNote(id: id, named: note.name, text: note.text, isFavourite: false, creationDate: Date(), deletionDate: nil, updateDeletion: true)
        }
    }
    
    func switchFavourite(forNoteWithId id: Int) {
        if let index = notes.firstIndex(where: {$0.id == id}) {
            let note = notes[index]
            notes[index].isFavourite.toggle()
            updateCoreNote(id: id, named: note.name, text: note.text, isFavourite: notes[index].isFavourite, creationDate: Date(), deletionDate: nil, updateFavor: true)
        }
    }
    
    func filterBy(tags: Set<String>) -> [Note] {
        return notes.filter {tags.isSubset(of: $0.tags)}
    }
    
    private func searchBy(name: String) -> [Note] {
        return notes.filter {$0.name.localizedLowercase.contains(name)}
    }
    
    private func searchDeletedBy(name: String) -> [Note] {
        return deletedNotes.filter {$0.name.localizedLowercase.contains(name)}
    }
    
    func sortedByDate() -> [Note] {
        return notes.sorted(by: {
            $0.creationDate.compare($1.creationDate) == .orderedDescending
        })
    }
    
    // Could be useful, maybe delete later, filtering
    func getFavorites() -> [Note] {
         return notes.filter {$0.isFavourite}
    }
    
    
    private func isNoteNameUnique(_ name: String) -> Bool {
        return !notes.contains(where: {$0.name == name})
    }
    
    func deleteNoteForever(with id: Int) {
        if let index = deletedNotes.firstIndex(where: {$0.id == id}) {
            deletedNotes.remove(at: index)
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [Int32(id)])
        
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            if (result.count == 1) {
                let managedObject = result.first!
                persistentContainer.viewContext.delete(managedObject)
                saveContext()
            }
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func updateCoreNote(id:Int, named name:String, text: String, isFavourite:Bool, creationDate: Date, deletionDate:Date?, updateFavor:Bool = false, updateCreation:Bool = false, updateDeletion:Bool = false) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [Int32(id)])
        
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            if (result.count == 1) {
                let managedObject = result.first!
                managedObject.setValue(name, forKey: "name")
                managedObject.setValue(text, forKey: "text")
                
                if(updateFavor) {
                    managedObject.setValue(isFavourite, forKey: "isFavourite")
                }
                
                if(updateCreation) {
                    managedObject.setValue(creationDate, forKey: "creationDate")
                }
                
                if(updateDeletion) {
                    managedObject.setValue(deletionDate, forKey: "deletionDate")
                }
                saveContext()
            }
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func prepareForUse(){
        var maxId = 0;
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            print(results)
            for (note) in results {
                guard let id = note.value(forKeyPath: "id") as? Int else {
                    print("id skip")
                    continue
                }
                guard let text = note.value(forKeyPath: "text") as? String else {
                    print("text skip")
                    continue
                }
                guard let name = note.value(forKeyPath: "name") as? String else {
                    print("name skip")
                    
                    continue
                    
                }
                print("fetched item")
                
                maxId = max(maxId, id)
               
                guard let isFavourite = note.value(forKeyPath: "isFavourite") as? Bool else { continue }
                guard let creationDate = note.value(forKeyPath: "creationDate") as? Date else { continue }
                let deletionDate = note.value(forKeyPath: "name") as? Date
                
                var note = Note(named: name, text: text, id: id)
                note.isFavourite = isFavourite
                note.creationDate = creationDate
                note.deletionDate = deletionDate
                
                if(deletionDate == nil) {
                    notes.append(note)
                } else {
                    deletedNotes.append(note)
                }
            }
            Note.idFactory = maxId
        } catch let nserror as NSError {
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        print("fetched")
        print(notes)
        print(deletedNotes)
    }
}
