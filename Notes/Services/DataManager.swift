//
//  DataManager.swift
//  Notes
//
//  Created by Алексей Колыченков on 13.03.2025.
//

import Foundation

protocol DataManagerProtocol {
    var networkManager: Networking {get set}
    var dataBaseManager: DataBaseManagerProtocol {get set}
    func getAllNotes(_ completion: @escaping ([Todo]) -> Void)
}

final class DataManager: DataManagerProtocol {
    var networkManager: Networking
    var dataBaseManager: DataBaseManagerProtocol
    
    init(networkManager: Networking = NetworkManager(), dataBaseManager: DataBaseManagerProtocol = DataBaseManager()) {
        self.networkManager = networkManager
        self.dataBaseManager = dataBaseManager
    }
    
    func getAllNotes(_ completion: @escaping ([Todo]) -> Void) {
        dataBaseManager.getAllNotes { notes in
            if !notes.isEmpty {
                completion(notes)
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
                            }
                    }
                }
            }
        }
    }
}
