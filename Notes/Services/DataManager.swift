//
//  DataManager.swift
//  Notes
//
//  Created by Алексей Колыченков on 13.03.2025.
//

import Foundation
import Combine

protocol DataManagerProtocol {
    var networkManager: Networking {get set}
    var dataBaseManager: DataBaseManagerProtocol {get set}
    func getAllNotes(_ completion: @escaping ([Todo]) -> Void)
    func updateNote(note: Todo, _ completion: @escaping ([Todo]) -> Void)
    var fetchedNotes: [Todo] {get}
}

final class DataManager: DataManagerProtocol {
    var networkManager: Networking
    var dataBaseManager: DataBaseManagerProtocol
    @Published var fetchedNotes: [Todo] = []
    
    init(networkManager: Networking = NetworkManager(), dataBaseManager: DataBaseManagerProtocol = DataBaseManager()) {
        self.networkManager = networkManager
        self.dataBaseManager = dataBaseManager
    }
    
    func getAllNotes(_ completion: @escaping ([Todo]) -> Void) {
        dataBaseManager.getAllNotes { [weak self] notes in
            guard let self = self else { return }
            if !notes.isEmpty {
                completion(notes)
                self.fetchedNotes = notes
                print("Запрос к БД")
            } else {
                print("Запрос к серверу")
                self.networkManager.downloadingData { notesFromNetwork in
                    switch notesFromNetwork {
                    case .failure(let error):
                        print("Error downloading Data: \(error)")
                    case .success(let notes):
                        print("Данные от сервера загружены")
                            self.dataBaseManager.saveAll(notes: notes) { [weak self] in
                                completion(notes) //отправляем заметки после сохранения
                                self?.fetchedNotes = notes
                            }
                    }
                }
            }
        }
    }
    
    func updateNote(note: Todo, _ completion: @escaping ([Todo]) -> Void) {
        do {
            try dataBaseManager.update(note: note)
            dataBaseManager.getAllNotes { [weak self] notes in
//                completion(notes)
                self?.fetchedNotes = notes
            }
        } catch {
            print("Error updateNote - \(error.localizedDescription)")
        }
    }
    
    func addNote(_ note: Todo, _ completion: @escaping ([Todo]) -> Void) {
        dataBaseManager.save(note: note)
        dataBaseManager.getAllNotes { [weak self] notes in
            self?.fetchedNotes = notes
        }
 
    }
    
    func deleteNote(at indexSet: IndexSet) {
        dataBaseManager.deleteNote(at: indexSet)
        dataBaseManager.getAllNotes {[weak self] notes in
            DispatchQueue.main.async {
                self?.fetchedNotes = notes
            }
        }
    }
    
    func delete(todo: Todo) {
        dataBaseManager.delete(note: todo)
        dataBaseManager.getAllNotes { [weak self] notes in
            self?.fetchedNotes = notes
        }
    }
}
