//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import Foundation

//protocol NotesListVMProtocol {
//    var dbManager: DataManagerProtocol {get set}
//    var notes: [Todo] {get}
//}

final class NotesListViewModel: ObservableObject {
    
    private let dataManager: DataManagerProtocol
    @Published var notes: [Todo] = []
    @Published var searchText: String = ""
    @Published var selectedTodo: Todo? {
        didSet {
            updateTodo()
        }
    }
//    @Published var errorMessage: String?
    
    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
        DispatchQueue.global().async {
            dataManager.getAllNotes { [weak self] todos in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.notes = todos
                }
            }
        }
    }
    
    func updateTodo() {
        guard let selectedTodo else { return }
        let updatedTodo = selectedTodo.updateSelf()
        dataManager.updateNote(note: updatedTodo) { notes in
            self.notes = notes
        }
    }

}

