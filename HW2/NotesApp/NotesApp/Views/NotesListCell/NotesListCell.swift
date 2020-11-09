//
//  NotesListCell.swift
//  NotesApp
//
//  Created by Viacheslav Bernadzikovskyi on 08.11.2020.
//

import UIKit

class NotesListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cellTextLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func editItem(_ sender: Any) {
        coordinator?.editNote(manager: notesManager!, itemId: itemId!)
    }
    
    @IBAction func removeItem(_ sender: Any) {
        notesManager?.deleteNote(with: itemId!)
        let tableView = self.superview as! UITableView
        tableView.reloadData()
    }
    
    weak var notesManager: NoteDataManager?
    weak var coordinator: MainCoordinator?
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
    
    func configure(with note: Note, manager: NoteDataManager, coordinator: MainCoordinator?){
        titleLabel.text = note.name
        cellTextLabel.text = note.text
        dateLabel.text = note.creationDate.description
        notesManager = manager
        itemId = note.id
        self.coordinator = coordinator
    }
}
