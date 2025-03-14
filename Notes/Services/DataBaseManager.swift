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
    func update(note: Todo) throws
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
//        applyChanges(context: <#NSManagedObjectContext#>)
        getTasks()
    }
    
   func update(note: Todo) throws {
       let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
//       request.predicate = NSPredicate(format: "id == %@", note.id)
       request.predicate = NSPredicate(format: "id == %d", note.id)
       do {
           let fetchedEntities = try container.viewContext.fetch(request)
           guard let entity = fetchedEntities.first else { return }
           entity.id = Int64(note.id)
           entity.todo = note.todo
           entity.completed = note.completed
           applyChanges(context: container.viewContext)
       } catch {
           throw error
       }
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
   
    private func applyChanges(context: NSManagedObjectContext) {
        save(context: context)
       getTasks()
   }
}
