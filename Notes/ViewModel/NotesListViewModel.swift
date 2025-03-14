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
    
    func updateNote() {
        dataManager.getAllNotes { todos in
            self.notes = todos
        }
    }
    
//    func fetchTasksfromNetwork() {
//        networkManager.downloadingData { [weak self] result in
//            switch result {
//            case .success(let tasks):
//                self?.tasks = tasks
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//                self?.errorMessage = error.errorDescription
//            }
//        }
//    }
}

private extension NotesListViewModel {
 
}
