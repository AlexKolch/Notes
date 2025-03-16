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
    @Published var isLoading: Bool = true
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
                    self.isLoading.toggle()
                }
            }
        }
        addSubscribers()
    }
    
    func updateStatusTodo() {
        guard let selectedTodo else { return }
        let updatedTodo = selectedTodo.updateStatusTodo()
        dataManager.updateNote(note: updatedTodo)
    }
    
    func updateTodo(newTodo: String) {
        guard let selectedTodo else { return }
        DispatchQueue.global().async { [weak self] in
            let updatedTodo = selectedTodo.updateSelf(newTodo: newTodo)
            self?.dataManager.updateNote(note: updatedTodo)
        }
//        let updatedTodo = selectedTodo.updateSelf(newTodo: newTodo)
//        dataManager.updateNote(note: updatedTodo)
    }
    
    func addTodo(newTodo: Todo) {
        DispatchQueue.global().async { [weak self] in
            self?.dataManager.addNote(newTodo)
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        DispatchQueue.global().async { [weak self] in
            self?.dataManager.deleteNote(at: offsets) { notes in
                DispatchQueue.main.async {
                    self?.notes = notes
                }
            }
        }
       
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
            .debounce(for: .seconds(0.4), scheduler: DispatchQueue.global())
            .map { text, todos in
                self.filterTodos(inputText: text, todos: todos)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedTodos in
                self?.notes = returnedTodos
            }
            .store(in: &cancellables)
    }

}

