//
//  DeletedNotesListCell.swift
//  NotesApp
//
//  Created by Viacheslav Bernadzikovskyi on 08.11.2020.
//

import UIKit

class DeletedNotesListCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cellTextLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func restoreNote(_ sender: Any) {
        notesManager?.restoreNote(with: itemId!)
        let tableView = self.superview as! UITableView
        tableView.reloadData()
    }
    
    @IBAction func deleteNoteForever(_ sender: Any) {
        notesManager?.deleteNoteForever(with: itemId!)
        let tableView = self.superview as! UITableView
        tableView.reloadData()
    }
    
    weak var notesManager: NoteDataManager?
    var itemId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        cellTextLabel.text = nil
        dateLabel.text = nil
    }
    
    func configure(with note: Note, manager: NoteDataManager){
        titleLabel.text = note.name
        cellTextLabel.text = note.text
        dateLabel.text = note.creationDate.description
        notesManager = manager
        itemId = note.id
    }
}
