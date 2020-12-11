//
//  Note.swift
//  NotesApp
//
//  Created by Viacheslav Bernadzikovskyi on 08.11.2020.
//

import Foundation

struct Note: Hashable {
    var name: String
    var text: String
    var tags: Set<String>
    var isFavourite = false
    var creationDate = Date()
    var deletionDate: Date?
    
    private(set) var id: Int
    
    static var idFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        idFactory += 1
        return Note.idFactory
    }

    init(named name:String, text: String = "", tags: Set<String> = [], id:Int = Note.getUniqueIdentifier()) {
        self.id = id
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
