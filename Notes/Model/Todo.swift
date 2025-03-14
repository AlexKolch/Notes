//
//  Todo.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import Foundation

struct Welcome: Decodable {
    let todos: [Todo]
    let total, skip, limit: Int
}

// MARK: - Todo
struct Todo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    
    init(id: Int, todo: String, completed: Bool) {
        self.id = id
        self.todo = todo
        self.completed = completed
    }
    
    //для создания NoteEntity
    init(entity: NoteEntity) {
        self.id = Int(entity.id)
        self.todo = entity.todo ?? ""
        self.completed = entity.completed
    }

}
