//
//  NoteDataManager.swift
//  NotesApp
//
//  Created by Viacheslav Bernadzikovskyi on 08.11.2020.
//

import Foundation

class NoteDataManager {
    private(set) var notes: [Note] = []
    private(set) var deletedNotes = [Note]()
    
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
            notes.append(Note(named: name, text: text, tags: tags))
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
    }
    
    func deleteNote(with id: Int) {
        if let index = notes.firstIndex(where: {$0.id == id}) {
            var note = notes[index]
            note.deletionDate = Date()
            deletedNotes.append(note)
            notes.remove(at: index)
            
        }
    }
    
    func restoreNote(with id: Int) {
        if let index = deletedNotes.firstIndex(where: {$0.id == id}) {
            var note = deletedNotes[index]
            note.deletionDate = nil
            notes.append(note)
            deletedNotes.remove(at: index)
        }
    }
    
    func switchFavourite(forNoteWithId id: Int) {
        if let index = notes.firstIndex(where: {$0.id == id}) {
            notes[index].isFavourite.toggle()
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
    }
}
