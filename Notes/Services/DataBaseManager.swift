//
//  DataBaseManager.swift
//  Notes
//
//  Created by Алексей Колыченков on 13.03.2025.
//

import Foundation
import CoreData

protocol DataBaseManagerProtocol {
    func getAllNotes(_ completion: @escaping ([Todo]) -> Void)
    var savedTasks: [NoteEntity] {get}
//    func findOrCreate(_ note: Todo, context: NSManagedObjectContext) throws
    func saveAll(notes: [Todo], _ completion: @escaping () -> Void)
    func removeNote(_ note: Todo)
}

final class DataBaseManager: DataBaseManagerProtocol {
    
    private let container: NSPersistentContainer
    private let containerName = "NotesContainer"
    private let entityName = "NoteEntity"
    @Published var savedTasks: [NoteEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error {
                print("Error loading CoreData! \(error)")
            }
            self.getTasks()
        }
    }
    
    func getAllNotes(_ completion: @escaping ([Todo]) -> Void) {
        let viewContext = container.viewContext
        viewContext.perform {
            let notesEntities = try? NoteEntity.all(viewContext)
            let users = notesEntities?.map({ entity in
                Todo(entity: entity)
            })
            completion(users ?? [])
        }
    }
    
    func saveAll(notes: [Todo], _ completion: @escaping () -> Void) {
        let context = container.viewContext
        context.perform {
            for note in notes {
                try? NoteEntity.findOrCreate(note, context: context)
            }
            self.save(context: context)
        
            completion()
            print("Данные от сервера успешно сохранены в БД")
        }
    }
    
    func removeNote(_ note: Todo) {
        guard let entity = savedTasks.first(where: {$0.id == note.id}) else {
            return
        }
        remove(entity: entity)
    }
    
    private func getTasks() {
        let request = NSFetchRequest<NoteEntity>(entityName: entityName)
       do {
           savedTasks = try container.viewContext.fetch(request)
       } catch let error {
           print("Error fetching Todo entities - \(error)")
       }
   }
    
    ///Добавить новую сущность в контекст контейнера
    private func add(note: Todo) {
    
        let entity = NoteEntity(context: container.viewContext)
      
        entity.id = Int64(note.id)
    
        entity.todo = note.todo
        entity.completed = note.completed
     
//        applyChanges()

    }
    
    ///удалить сущность
    private func remove(entity: NoteEntity) {
        container.viewContext.delete(entity)
        applyChanges()
        getTasks()
    }
    
    private func update(entity: NoteEntity, note: Todo) {
        entity.id = Int64(note.id)
        entity.todo = note.todo
        entity.completed = note.completed
        applyChanges()
    }
   
    private func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error {
                print("Error saving to CoreData - \(error)")
            }
        }
   }
   
    private func applyChanges() {
//        save(context: <#NSManagedObjectContext#>)
//       getTasks()
   }
}
