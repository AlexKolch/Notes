//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import Foundation
import SwiftfulRouting
//protocol NotesListVMProtocol {
//    var dbManager: DataManagerProtocol {get set}
//    var notes: [Todo] {get}
//}

final class NotesListViewModel: ObservableObject {
    private let dataManager: DataManagerProtocol
    let router: AnyRouter
    @Published var notes: [Todo] = []
    @Published var searchText: String = ""
    @Published var selectedTodo: Todo? 
//    @Published var errorMessage: String?
    
    init(dataManager: DataManagerProtocol = DataManager(), router: AnyRouter) {
        self.dataManager = dataManager
        self.router = router
        DispatchQueue.global().async {
            dataManager.getAllNotes { [weak self] todos in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.notes = todos
                }
            }
        }
    }
    
    func updateStatusTodo() {
        guard let selectedTodo else { return }
        let updatedTodo = selectedTodo.updateStatusTodo()
        dataManager.updateNote(note: updatedTodo) { notes in
            self.notes = notes
        }
    }
    
    func updateTodo(newTodo: String) {
        guard let selectedTodo else { return }
        let updatedTodo = selectedTodo.updateSelf(newTodo: newTodo)
        dataManager.updateNote(note: updatedTodo) { notes in
            self.notes = notes
        }
    }

}

