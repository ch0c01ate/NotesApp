import UIKit

struct Note: Hashable {
    var name: String
    var text: String
    var tags: Set<String>
    var isFavourite = false
    var creationDate = Date()
    var deletionDate: Date?
    
    private(set) var id: Int
    
    private static var idFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        idFactory += 1
        return Note.idFactory
    }

    init(named name:String, text: String = "", tags: Set<String> = []) {
        self.id = Note.getUniqueIdentifier()
        self.name = name
        self.text = text
        self.tags = tags
    }
    
    // Could be useful, maybe delete later
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

class NoteDataManager {
    private(set) var notes = [Note]()
    private var deletedNotes = [Note]()
    
    func createNote(named name:String, text: String = "", tags: Set<String> = []) {
        if(isNoteNameUnique(name)){
            notes.append(Note(named: name, text: text, tags: tags))
        } else {
            // TODO: throw error or maybe reimplement to return true/false
        }
    }
    
    func getNote(with id:Int) -> Note? {
        return notes.filter({ $0.id == id }).first // Hint: .first(where:)
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
            deletedNotes.append(notes[index])
            notes.remove(at: index)
        }
    }
    
    func restoreNote(with id: Int) {
        if let index = deletedNotes.firstIndex(where: {$0.id == id}) {
            notes.append(notes[index])
            deletedNotes.remove(at: index)
        }
    }
    
    func switchFavourite(forNoteWithId id: Int) {
        if let index = notes.firstIndex(where: {$0.id == id}) {
            notes[index].isFavourite = !notes[index].isFavourite // Hint: .toggle()
        }
    }
    
    // TODO: add creation date if neccessary
    func filterBy(tags: Set<String>) -> Array<Note> { // Hint: [Note] instead of Array<>
        return notes.filter {tags.isSubset(of: $0.tags)}
    }
    
    func searchBy(name: String) -> Array<Note> {
        return notes.filter {$0.name.localizedLowercase.contains(name)}
    }
    
    func sortedByDate() -> Array<Note> {
        return notes.sorted(by: {
            $0.creationDate.compare($1.creationDate) == .orderedDescending // Hint: Also you can compare dates with <, > overloaded method
        })
    }
    
    
    // Could be useful, maybe delete later, filtering
    func getFavorites() -> Array<Note> {
         return notes.filter {$0.isFavourite}
    }
    
    
    private func isNoteNameUnique(_ name: String) -> Bool {
        return notes.filter({ $0.name == name }).count == 0 // Hint: .contains(where:)
    }
}

// No tests provided

let manager = NoteDataManager()
manager.createNote(named: "name", text: "text", tags: ["tag"])

print(manager.notes)
manager.switchFavourite(forNoteWithId: 1)
print(manager.getNote(with: 1))
manager.createNote(named: "name", text: "text", tags: ["tag"])
print(manager.notes)
manager.deleteNote(with: 1)
print(manager.notes)
