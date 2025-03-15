//
//  NoteEntity.swift
//  Notes
//
//  Created by Алексей Колыченков on 13.03.2025.
//

import Foundation
import CoreData

class NoteEntity: NSManagedObject {
    
    static func findOrCreate(_ note: Todo, context: NSManagedObjectContext) throws -> NoteEntity {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", note.id)
        do {
            let fetchResults = try context.fetch(request)
            if fetchResults.count > 0 {
                assert(fetchResults.count == 1, "Dublicate has been found in DB")
            }
        } catch {
            throw error
        }
      
        let entity = NoteEntity(context: context)
        entity.id = Int64(note.id)
        entity.todo = note.todo
        entity.completed = note.completed
        return entity
    }
    
    static func fetchAll(_ context: NSManagedObjectContext) throws -> [NoteEntity] {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
}
