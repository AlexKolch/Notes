//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import Foundation
import SwiftfulRouting
import Combine
//protocol NotesListVMProtocol {
//    var dbManager: DataManagerProtocol {get set}
//    var notes: [Todo] {get}
//}

final class NotesListViewModel: ObservableObject {
    private let dataManager: DataManager
    let router: AnyRouter
    @Published var notes: [Todo] = []
    @Published var searchText: String = ""
    @Published var selectedTodo: Todo?
    private var cancellables = Set<AnyCancellable>()
//    @Published var errorMessage: String?
    
    init(dataManager: DataManager = DataManager(), router: AnyRouter) {
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
        addSubscibers()
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
    
    private func filterTodos(inputText: String, todos: [Todo]) -> [Todo] {
        guard !inputText.isEmpty else {
            return todos
        }
        let searchingLowercasedText = inputText.lowercased()
        return todos.filter {
            $0.todo.lowercased().contains(searchingLowercasedText)
        }
    }
    
    private func addSubscibers() {
        $searchText
            .combineLatest(dataManager.$fetchedNotes)
            .debounce(for: .seconds(0.4), scheduler: DispatchQueue.main)
            .map { text, todos in
                self.filterTodos(inputText: text, todos: todos)
            }
            .sink { [weak self] returnedTodos in
                self?.notes = returnedTodos
            }
            .store(in: &cancellables)
    }

}

