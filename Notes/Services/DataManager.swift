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
        dataBaseManager.getAllNotes { notes in
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
                            self.dataBaseManager.saveAll(notes: notes) {
                                completion(notes) //отправляем заметки после сохранения
                                self.fetchedNotes = notes
                            }
                    }
                }
            }
        }
    }
    
    func updateNote(note: Todo, _ completion: @escaping ([Todo]) -> Void) {
        do {
            try dataBaseManager.update(note: note)
            dataBaseManager.getAllNotes { notes in
                completion(notes)
            }
        } catch {
            print("Error updateNote - \(error.localizedDescription)")
        }
    }
}
