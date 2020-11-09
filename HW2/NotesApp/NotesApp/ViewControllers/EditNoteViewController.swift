//
//  EditNoteViewController.swift
//  NotesApp
//
//  Created by Viacheslav Bernadzikovskyi on 08.11.2020.
//

import UIKit

class EditNoteViewController: UIViewController, Storyboarded {
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var textTextField: UITextField!
    
    @IBAction func editItem(_ sender: UIButton) {
        notesManager?.updateNote(with: itemId!, name: titleTextField.text ?? "Untitled", text: textTextField.text ?? "", tags: Set<String>())
        navigationController?.popViewController(animated: true)
    }
    
    weak var coordinator: MainCoordinator?
    
    weak var notesManager: NoteDataManager?
    var itemId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        let note = notesManager?.getNote(with: itemId!)
        titleTextField.text = note?.name
        textTextField.text = note?.text
    }
}
