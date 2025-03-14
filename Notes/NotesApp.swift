//
//  NotesApp.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import SwiftUI
import CoreData

@main
struct NotesApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NotesListView()
                    .preferredColorScheme(.dark)
            }
          
        }
    }
}
