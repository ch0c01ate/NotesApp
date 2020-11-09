//
//  CreateNoteViewController.swift
//  NotesApp
//
//  Created by Viacheslav Bernadzikovskyi on 08.11.2020.
//

import UIKit

class CreateNoteViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    weak var notesManager: NoteDataManager?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var noteTextTextField: UITextField!
    
    @IBAction func goBack(_ sender: UIButton) {
        print(notesManager?.notes.count)
        notesManager?.createNote(named: titleTextField.text ?? "Untitled", text: noteTextTextField.text ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
