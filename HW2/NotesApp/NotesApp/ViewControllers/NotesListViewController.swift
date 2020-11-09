//
//  ViewController.swift
//  NotesApp
//
//  Created by Viacheslav Bernadzikovskyi on 08.11.2020.
//

import UIKit

class NotesListViewController: UIViewController, Storyboarded {
    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: MainCoordinator?
    
    var resultSearchController = UISearchController()
    
    var dataSource = [Note]()
    
    @IBAction func addNoteItem(_ sender: UIBarButtonItem) {
        coordinator?.createNote(manager: notesManager)
    }
    
    private var notesManager = NoteDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let imageNib = UINib(nibName: "NotesListCell", bundle: nil)
        tableView.register(imageNib, forCellReuseIdentifier: "NotesListCell")
        
        let textNib = UINib(nibName: "DeletedNotesListCell", bundle: nil)
        tableView.register(textNib, forCellReuseIdentifier: "DeletedNotesListCell")
        
        resultSearchController = ({
                let controller = UISearchController(searchResultsController: nil)
                controller.searchResultsUpdater = self
                controller.searchBar.sizeToFit()

                tableView.tableHeaderView = controller.searchBar

                return controller
            })()
    }
    
}

extension NotesListViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return AppConstants.notesListSectionNumber;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? AppStrings.notes : AppStrings.deletedNotes
    }
}

extension NotesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sad = section == 0 ? notesManager.getNotes().count : notesManager.getDeletedNotes().count
        return sad
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotesListCell") as? NotesListCell else {
                fatalError()
            }
            cell.configure(with: notesManager.getNotes()[indexPath.row], manager: notesManager, coordinator: coordinator)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeletedNotesListCell") as? DeletedNotesListCell else {
                fatalError()
            }
            cell.configure(with: notesManager.getDeletedNotes()[indexPath.row], manager: notesManager)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension NotesListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController)
    {
        if(searchController.searchBar.text! == ""){
            notesManager.searchQuery = nil
        } else {
            notesManager.searchQuery = searchController.searchBar.text!
        }
        tableView.reloadData()
    }
}
