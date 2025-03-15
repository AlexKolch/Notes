//
//  DataBaseManager.swift
//  Notes
//
//  Created by Алексей Колыченков on 13.03.2025.
//

import Foundation
import CoreData

protocol DataBaseManagerProtocol {
    var savedEntity: [NoteEntity] {get}
    func getAllNotes(_ completion: @escaping ([Todo]) -> Void)
    func saveAll(notes: [Todo], _ completion: @escaping () -> Void)
    func update(note: Todo) throws
    func save(note: Todo)
    func deleteNote(at indexSet: IndexSet)
}

final class DataBaseManager: DataBaseManagerProtocol {
    
    private let container: NSPersistentContainer
    private let containerName = "NotesContainer"
    private let entityName = "NoteEntity"
    
    @Published var savedEntity: [NoteEntity] = []
    
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
            let notesEntities = try? NoteEntity.fetchAll(viewContext)
            let notes = notesEntities?.map({ entity in
                Todo(entity: entity)
            })
            completion(notes ?? [])
        }
    }
    
    func saveAll(notes: [Todo], _ completion: @escaping () -> Void) {
        let context = container.viewContext
        context.perform {
            for note in notes {
               _ = try? NoteEntity.findOrCreate(note, context: context)
            }
            self.save(context: context)
        
            completion()
            print("Данные от сервера успешно сохранены в БД")
        }
    }
    
    
    private func getTasks() {
        let request = NSFetchRequest<NoteEntity>(entityName: entityName)
       do {
           savedEntity = try container.viewContext.fetch(request)
       } catch let error {
           print("Error fetching Todo entities - \(error)")
       }
   }
    
    ///Добавить новую сущность в контекст контейнера
    func save(note: Todo) {
        let context = container.viewContext
        context.perform { [weak self] in
            _ = try? NoteEntity.findOrCreate(note, context: context)
            self?.applyChanges(context: context)
        }
    }
    
    func deleteNote(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entityToDelete = savedEntity[index]
        container.viewContext.delete(entityToDelete)
        applyChanges(context: container.viewContext)
    }
    
   func update(note: Todo) throws {
       let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
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
   
}

private extension DataBaseManager {
     func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error {
                print("Error saving to CoreData - \(error)")
            }
        }
   }
   
     func applyChanges(context: NSManagedObjectContext) {
        save(context: context)
        getTasks()
    }
}
