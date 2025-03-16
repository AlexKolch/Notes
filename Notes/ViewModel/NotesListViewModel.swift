//
//  NotesListViewModel.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import Foundation
import SwiftfulRouting
import Combine


final class NotesListViewModel: ObservableObject {
    private let dataManager: DataManager
    let router: AnyRouter
    @Published var notes: [Todo] = []
    @Published var searchText: String = ""
    @Published var selectedTodo: Todo?
    private var cancellables = Set<AnyCancellable>()
    
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
        addSubscribers()
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
    
    func addTodo(newTodo: Todo) {
        dataManager.addNote(newTodo) { todos in
            self.notes = todos
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        dataManager.deleteNote(at: offsets)
    }
    
    func delete(todo: Todo) {
        dataManager.delete(todo: todo)
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
    
    private func addSubscribers() {
        dataManager.$fetchedNotes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] todos in
                self?.notes = todos
            }
            .store(in: &cancellables)
        
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
        
        dataManager.$fetchedNotes
            .sink { [weak self] todos in
                self?.notes = todos
            }
            .store(in: &cancellables)
    }

}

